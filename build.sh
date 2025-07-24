docker build -t 05jchambers/legendary-bedrock-container:amd64 -f amd64.Dockerfile .
docker push 05jchambers/legendary-bedrock-container:amd64

docker build -t 05jchambers/legendary-bedrock-container:arm64v8 -f arm64v8.Dockerfile .
docker push 05jchambers/legendary-bedrock-container:arm64v8

docker build -t 05jchambers/legendary-bedrock-container:armv7 -f armv7.Dockerfile .
docker push 05jchambers/legendary-bedrock-container:armv7

docker build -t 05jchambers/legendary-bedrock-container:ppc64le -f ppc64le.Dockerfile .
docker push 05jchambers/legendary-bedrock-container:ppc64le

docker build -t 05jchambers/legendary-bedrock-container:s390x -f s390x.Dockerfile .
docker push 05jchambers/legendary-bedrock-container:s390x

docker build -t 05jchambers/legendary-bedrock-container:pi5-16k -f pi5-16k.Dockerfile .
docker push 05jchambers/legendary-bedrock-container:pi5-16k

docker build -t 05jchambers/legendary-bedrock-container:pi5 -f pi5.Dockerfile .
docker push 05jchambers/legendary-bedrock-container:pi5

docker build -t 05jchambers/legendary-bedrock-container:rk3588 -f rk3588.Dockerfile .
docker push 05jchambers/legendary-bedrock-container:rk3588

./manifest-tool-linux-amd64 push from-spec multi-arch-manifest.yaml
