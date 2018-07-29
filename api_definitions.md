# API Definitions Documentation #

The Men and Mice SOAP WSDL is pre-processed into local definition files so
that we do not require a dependency on a SOAP/XML parser during runtime. Each
major version of the gem supports a different version of the M&M API by default,
but can be overridden if needed.


## Default Definitions ##

The default API definitions are shipped with the gem and are in:
`lib/mm_json_client/api_definitions`

The files are:

* enums.json
* methods.json
* types.json

## Generating Definitions ##

These steps will generate new definition files.

1. Download the SOAP API WSDL from your M&M instance.
    * `http://<web_app_server/_mmwebext/mmwebext.dll?WSDL`
    * `http://<web_app_server/_mmwebext/mmwebext.dll?WSDL?server=<mm_central>`
2. Open a shell to the base directory of this project.
3. Use `bundle install` to install all of the required dependencies.
4. Generate the definition files.
    ```bash
    MM_DEF_DIR=/tmp/new_defs
    MM_WSDL=$MM_DEF_DIR/mm_91.wsdl.xml

    bundle exec rake generate:enum_def $MM_WSDL $MM_DEF_DIR/enums.json
    bundle exec rake generate:method_def $MM_WSDL $MM_DEF_DIR/methods.json
    bundle exec rake generate:type_def $MM_WSDL $MM_DEF_DIR/types.json
    ```

## Overriding the Defaults ##

Most of the time, simply switching to a different gem version is the simplest
way to access a different M&M API version, but if you have a need to use your
own generated definition files, you can follow these steps.

1. Generate the definition files and place them in a directory accessible from
   your application.
1. Set the environment variable `API_DEF_DIR` to the directory from step 1.