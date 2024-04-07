{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, pythonRelaxDepsHook
, attrs
, boto3
, cloudpickle
, google-pasta
, numpy
, protobuf
, smdebug-rulesconfig
, importlib-metadata
, packaging
, pandas
, pathos
, schema
, pyyaml
, jsonschema
, platformdirs
, tblib
, urllib3
, docker
, scipy
}:

buildPythonPackage rec {
  pname = "sagemaker";
  version = "2.214.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "sagemaker-python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-RE4uyIpFiZNDyS5R6+gMLlj0vcAIiHPattFPTSMGnCI=";
  };

  patches = [
    # Distutils removal, fix build with python 3.12
    # https://github.com/aws/sagemaker-python-sdk/pull/4544
    (fetchpatch {
      url = "https://github.com/aws/sagemaker-python-sdk/commit/84447ba59e544c810aeb842fd058e20d89e3fc74.patch";
      hash = "sha256-B8Q18ViB7xYy1F5LoL1NvXj2lnFPgt+C9wssSODyAXM=";
    })
    (fetchpatch {
      url = "https://github.com/aws/sagemaker-python-sdk/commit/e9e08a30cb42d4b2d7299c1c4b42d680a8c78110.patch";
      hash = "sha256-uGPtXSXfeaIvt9kkZZKQDuiZfoRgw3teffuxai1kKlY=";
    })
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "attrs"
    "boto3"
  ];

  propagatedBuildInputs = [
    attrs
    boto3
    cloudpickle
    google-pasta
    numpy
    protobuf
    smdebug-rulesconfig
    importlib-metadata
    packaging
    pandas
    pathos
    schema
    pyyaml
    jsonschema
    platformdirs
    tblib
  ];

  doCheck = false; # many test dependencies are not available in nixpkgs

  pythonImportsCheck = [
    "sagemaker"
    "sagemaker.lineage.visualizer"
  ];

  passthru.optional-dependencies = {
    local = [ urllib3 docker pyyaml ];
    scipy = [ scipy ];
    # feature-processor = [ pyspark sagemaker-feature-store-pyspark ]; # not available in nixpkgs
  };

  meta = with lib; {
    description = "Library for training and deploying machine learning models on Amazon SageMaker";
    homepage = "https://github.com/aws/sagemaker-python-sdk/";
    changelog = "https://github.com/aws/sagemaker-python-sdk/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ nequissimus ];
  };
}
