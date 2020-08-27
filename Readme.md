# Phoenix
Burn it all down so we might build again. A repo for building AMIs with Packer and Github Actions. 

## Setup
Local development

By default Packer will load all `pkr.hcl` files in the working directory when running `packer build`. 
1. `asdf plugin add act`
2. `act --secret-file .secrets`