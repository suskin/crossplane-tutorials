Now that all of our prerequisites are installed, let's create our
Stack! This roughly follows the Crossplane CLI's [quick
start][crossplane-cli-quick-start].

## Develop

First we'll create a new API for our first type.

`cd /root/go/src/helloworld`{{execute}}
`yes y | GO111MODULE=on kubebuilder create api --group samples --version v1alpha1 --kind HelloWorld`{{execute}}

Next, we'll initialize this as a Stack project. We like to call this
Stackification. Stackify the Stack!

`kubectl crossplane stack init --cluster 'crossplane-examples/hello-world'`{{execute}}

The reason we're using `--cluster` is so that we don't need to worry as
much about permissions for our example.

Next we'll add our Hello World logic! Open up the controller, which
should be in `/root/go/src/helloworld/controllers`{{open}}, and then add
this where you see the line that says `// your logic here`:

```
	r.Log.V(0).Info("Hello World!", "instance", req.NamespacedName)
```

## Validate locally

Now that we've added some logic, we'll build the controller. We'll use
the kubebuilder pattern for this, because that's what our project is
using for the controller.

`GO111MODULE=on make manager manifests`{{execute}}

Next, we'll build this as a Stack. The command we'll use is specific to
local builds that you'll want to do when developing (it's the
`local-build` argument which is special).

`kubectl crossplane stack build local-build`{{execute}}

Now we'll install the Stack that we built into our local Crossplane
control cluster:

`kubectl crossplane stack install --cluster 'crossplane-examples/hello-world' 'crossplane-examples-hello-world' localhost:5000`{{execute}}

Our Stack watches for helloworld objects, so to test the Stack, we
should create a helloworld object:

`kubectl apply -f config/samples/*.yaml`{{execute}}

If everything succeeded, we should be able to see output from our controller in its logs:

`pod_name="$( kubectl get pods -A | grep hello-world | grep -v Completed | awk '{ print $2 }' )" && kubectl logs "${pod_name}" | grep 'Hello World'`{{execute}}

That's it! We created a Stack!

## Cleanup

Once we're done with the Stack, we probably want to uninstall it.

`kubectl crossplane stack uninstall --cluster 'crossplane-examples-hello-world'`{{execute}}

[crossplane-cli-quick-start]: https://github.com/crossplaneio/crossplane-cli#quick-start-stacks
