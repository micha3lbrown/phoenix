source "amazon-ebssurrogate" "source" {
	associate_public_ip_address = true
	vpc_id = var.vpc_id
	subnet_id = var.subnet_id
	source_ami_filter {
		filters = {
			virtualization-type = "hvm"
			name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
			root-device-type = "ebs"
		}
		owners = [
			"099720109477" // Canonical
		]
		most_recent = true
	}

	instance_type = var.instance_type	
	region = var.region
	ena_support = true

	launch_block_device_mappings {
		device_name = "/dev/xvdf"
		delete_on_termination = true
		volume_size = 8
		volume_type = "gp2"
	}

	run_tags = {
		Name = "Packer Builder - ZFS Root Ubuntu"
	}
	run_volume_tags = {
		Name = "Packer Builder - ZFS Root Ubuntu"
	}

	communicator = "ssh"
	ssh_pty = true
	ssh_username = "ubuntu"
	ssh_timeout = "5m"

	ami_name = "ubuntu-focal-20.04-amd64-zfs-server-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
	ami_description = "Ubuntu Focal (20.04)"
	ami_virtualization_type = "hvm"
	ami_regions = []
	ami_root_device {
		source_device_name = "/dev/xvdf"
		device_name = "/dev/xvda"
		delete_on_termination = true
		volume_size = 8
		volume_type = "gp2"
	}

	tags = {
		Name = "Ubuntu Focal (20.04)"
	}
}

build {
	sources = [
		"source.amazon-ebssurrogate.source"
	]
	
	provisioner "shell" {
		script = "./build/scripts/hello-world.sh"
		execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
		skip_clean = true
	}

	provisioner "ansible-local" {
    	playbook_file = "./build/ansible/main.yaml"
    }
}