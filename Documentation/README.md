# Polycube Documentation

**The polycube documentation is available on [ReadTheDocs](https://polycube-network.readthedocs.io/en/latest/).**

The instructions below are intended if you want to generate the documentation locally.

## Building the documentation locally

### Installing the dependencies

Our documentation uses `sphinx`.
In order to install the dependencies do

```
cd Documentation
pip install -r Documentation/requirements.txt
```

### Build it

```
cd Documentation
make html
```

### Check spelling

```
cd Documentation
make spelling
```

The html documentation files will be in the `Documentation/_build` folder.
