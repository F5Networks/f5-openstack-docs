<!--
Copyright 2015 F5 Networks Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
# f5-openstack-docs
[![Build Status](https://travis-ci.com/F5Networks/f5-openstack-docs.svg?token=9DzDpZ48B74dRXvdFxM2&branch=develop)](https://travis-ci.com/F5Networks/f5-openstack-docs)

**http://f5networks.github.io/f5-openstack-docs**

## Introduction
This repo is used to publish documentation for all F5 OpenStack projects, via [Jekyll]() and [GitHub Pages](). We use [Travis CI]() and [HTML Proofer]() to build and test the site.* 

## F5 OpenStack projects

This site contains documentation for the following F5 OpenStack projects:

- [f5-openstack-lbaasv1](https://github.com/F5Networks/openstack-f5-lbaasv1)
- [f5-openstack-lbaasv2](https://github.com/F5Networks/f5-openstack-lbaasv2)
- [f5-openstack-agent](https://github.com/F5Networks/f5-openstack-agent)
- [f5-openstack-heat-plugins](https://github.com/F5Networks/f5-openstack-heat-plugins)
- [f5-icontrol-rest-python](https://github.com/F5Networks/f5-icontrol-rest-python)
- [f5-common-python](https://github.com/F5Networks/f5-common-python)

## Releases and Versioning

The F5 LBaaS plugin release cycle will match the [OpenStack Roadmap](https://www.openstack.org/software/roadmap/) starting with the Mitaka release. The website, http://f5networks.github.io/f5-openstack-docs, supports the current version of the plugin. Documentation for each previous version of the F5 LBaaS plugin can be accessed via the appropriate folder in this repo and the website. 

The compatibility matrix below shows which versions of the plugin can be used with which OpenStack releases and the compatible versions of BIG-IP.

OpenStack release | LBaaS version | Supported Plugin version | BIG-IP version
 |:---|---:|---:
 Mitaka | LBaaS v2 (coming soon!) | N/A | N/A
 Liberty | LBaaS v1 (coming soon!) | N/A | N/A 
 Kilo | LBaaS v1 | 1.0.10 | 11.5.x; 11.6.x; 12.0.x
 Juno | LBaaS v1 | 1.0.10 | 11.5.x; 11.6.x; 12.0.x
 Icehouse | LBaaS v1 | 1.0.10 | 11.5.x; 11.6.x; 12.0.x
 Havana | LBaaS v1| 1.0.10 | 11.5.x; 11.6.x; 12.0.x

## Filing Issues
If you find an issue we would love to hear about it.  Please let us know by filing an issue in this repository and tell us as much as you can about what you found and how you found it.

## Contributing
See [Contributing](CONTRIBUTING.md).

## Contact
\[add contact email\]

## Copyright
Copyright 2015-2016 F5 Networks, Inc.

## Acknowledgements
See [Acknowledgements](ACKNOWLEDGEMENTS.md)

## Support
See [Support](SUPPORT.md)

## License
### Apache V2.0
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 
### Contributor License Agreement
Individuals or business entities who contribute to this project must have completed and submitted the [F5 Contributor License Agreement](http://f5networks.github.io/f5-openstack-docs/cla_landing/index.html) to Openstack_CLA@f5.com prior to their
code submission being included in this project.


[Jekyll]:https://jekyllrb.com/
[Travis CI]:https://travis-ci.com/
[HTML Proofer]:https://github.com/gjtorikian/html-proofer
[GitHub Pages]:https://pages.github.com/
