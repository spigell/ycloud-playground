FROM ubuntu:20.04

RUN useradd -m user1
RUN useradd -m user2
USER user1

ENTRYPOINT [ "bash", "-c" ]

CMD [ "sleep infinity" ]

