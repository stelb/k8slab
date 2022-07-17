TMP=$(mktemp -d)

kubectl create secret generic $* \
--dry-run=client \
-o yaml > $TMP/basic-auth.yaml

kubeseal --fetch-cert  \
--controller-name=sealed-secrets-controller \
--controller-namespace=flux-system >$TMP/cert.pem

#-n default create secret generic basic-auth \
#--from-literal=user=admin \
#--from-literal=password=change-me \

#Encrypt the secret with kubeseal:

kubeseal --format=yaml --cert=$TMP/cert.pem < $TMP/basic-auth.yaml
#> basic-auth-sealed.yaml

#Delete the plain secret and apply the sealed one:

#rm basic-auth.yaml
#kubectl apply -f basic-auth-sealed.yaml

rm -rf $TMP
