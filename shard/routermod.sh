oc patch \
  -n openshift-ingress-operator \
  IngressController/default \
  --type='merge' \
  -p '{"spec":{"routeSelector":{"matchExpressions":[{"key":"type","operator":"NotIn","values":["sharded"]}]}}}'
