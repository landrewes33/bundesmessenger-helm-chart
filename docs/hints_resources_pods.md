# Clamav

The performance impact of running clamd in Docker is negligible. Docker is in essence just a wrapper around Linux's cgroups and cgroups can be thought of as chroot or FreeBSD's jail. All code is executed on the host without any translation. Docker does however do some isolation (through cgroups) to isolate the various systems somewhat.

Of course, nothing in life is free, and so there is some overhead. Disk-space being the most prominent one. The Docker container might have some duplication of files for example between the host and the container. Further more, also RAM memory may be duplicated for each instance, as there is no RAM-deduplication. Both of which can be solved on the host however. A filesystem that supports disk-deduplication and a memory manager that does RAM-deduplication.

The base container in itself is already very small ~16 MiB, at the time of this writing, this cost is still very tiny, where the advantages are very much worth the cost in general.

The container including the virus database is about ~240 MiB at the time of this writing.
