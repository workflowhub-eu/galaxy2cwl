#!/usr/bin/env python

# © Copyright 2019-2020 Ignacio Eguinoa, VIB, Universiteit Gent, and workflowhub.eu contributors
#
#
# SPDX-License-Identifier: BSD-3-Clause

__author__      = "Ignacio Eguinoa <https://orcid.org/0000-0002-6190-122X>"
__copyright__   = "© 2019-2020 Ignacio Eguinoa, VIB, Universiteit Gent, and workflowhub.eu contributors"
__license__     = "BSD-3-Clause"

from setuptools import setup, find_packages
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

with open(path.join(here, 'README.md'), encoding='utf-8') as f:
  long_description = f.read()

setup(
  name = 'galaxy2cwl',
  packages = find_packages(exclude=['contrib', 'docs', 'tests']), # Required
  version = "0.1.0",
  description = 'Convert a Galaxy workflow to abstract Common Workflow Language (CWL)',
  long_description=long_description,
  long_description_content_type="text/markdown",
  author = 'Ignacio Eguinoa',
  include_package_data=True,
  license = "BSD 3-Clause",
  url = 'https://github.com/workflowhub-eu/cwl-from-galaxy',
  keywords = "cwl galaxy workflow",
  
  install_requires=[
          'pyyaml >= 5.3.0',
          'gxformat2 >= 0.11.0'
  ],
#  tests_require=['pytest'],
  entry_points={
      'console_scripts': ["galaxy2cwl=galaxy2cwl.get_cwl_interface:main"]
  },
  python_requires='>=3.6, <4',
  classifiers=[
    # https://pypi.python.org/pypi?%3Aaction=list_classifiers
    'Development Status :: 2 - Pre-Alpha',
    'Intended Audience :: Developers',
    'Intended Audience :: Science/Research',
    'Topic :: Software Development :: Build Tools',
    'License :: OSI Approved :: BSD License',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.6',
    'Topic :: Scientific/Engineering :: Bio-Informatics',
    'Topic :: Utilities'
],
  
)
