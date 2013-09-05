Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:62301 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965202Ab3IEKe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 06:34:56 -0400
Date: Thu, 5 Sep 2013 12:32:04 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: WARNING with ath9k_htc on TL-WN721N
Message-ID: <20130905103204.GB1570@ritirata.org> (sfid-20130905_123500_959347_B0ADC4BA)
References: <20130905100914.GA1570@ritirata.org>
 <52285C02.8050205@rempel-privat.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
In-Reply-To: <52285C02.8050205@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

lsusb:

Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 1bcf:280b Sunplus Innovation Technology Inc.=20
Bus 002 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271 802.11n
Bus 002 Device 011: ID 03f0:8607 Hewlett-Packard Optical Mobile Mouse
Bus 002 Device 005: ID 0403:6001 Future Technology Devices International, L=
td
FT232 USB-Serial (UART) IC
Bus 002 Device 006: ID 413c:8187 Dell Computer Corp. DW375 Bluetooth Module


lspci:

00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family=
 DRAM
Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core
Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Ch=
ipset
Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Fami=
ly
USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family=
 High
Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family P=
CI
Express Root Port 1 (rev b4)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family P=
CI
Express Root Port 2 (rev b4)
00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family P=
CI
Express Root Port 3 (rev b4)
00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family P=
CI
Express Root Port 6 (rev b4)
00:1c.6 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family P=
CI
Express Root Port 7 (rev b4)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Fami=
ly
USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Contr=
oller
(rev 04)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Fam=
ily 6
port SATA AHCI Controller (rev 04)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus
Controller (rev 04)
02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Tay=
lor
Peak] (rev 34)
03:00.0 CardBus bridge: O2 Micro, Inc. Device 8134 (rev 06)
09:00.0 FireWire (IEEE 1394): O2 Micro, Inc. 1394 OHCI Compliant Host Contr=
oller
(rev 05)
09:00.1 SD Host controller: O2 Micro, Inc. Integrated MMC/SD controller (re=
v 05)
09:00.2 Mass storage controller: O2 Micro, Inc. O2 Flash Memory Card (rev 0=
5)
0a:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5761 Gigabit
Ethernet PCIe (rev 10)


I'm not using the Intel card listed in lspci. (the iwldvm module is loaded =
but
the interface is down).

Cheers,


On Thu, Sep 05, 2013 at 12:25:06PM +0200, Oleksij Rempel wrote:
> Am 05.09.2013 12:09, schrieb Antonio Quartulli:
> > Hello list,
> >
> > I ma connected to my WPA2-PSK protected network and from time to time I=
 get the
> > following warning in dmesg. I don't experience any malfunctionng but I =
thought
> > it was worth reporting. My kernel version is linux-3.10.10. I remember =
I've seen
> > this warning also with previous versions.
> >
> > The device I use is a TP-LINK TL-WN721N.
> > lsusb says:
> >
> > Bus 002 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271 80=
2.11n
> >
> > Cheers,
> >
>=20
> Hi Antonio,
>=20
> pleas send out of lsusb and lspci.
>=20
>=20
> --=20
> Regards,
> Oleksij

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKF2kAAoJEADl0hg6qKeOVxsP/iHZwqcNE8sgAaO2ne1ylbiA
Jli1jA9dHmfnVlhMeZucMdeeWEfEt6O0P/lrkoz4ATcpfNIfOmAGyXr2vFCNBbdn
pWD4A0fxvTytSqSsGsdL7rGd2GB6F8bVFhJnyxGh4L1CgDTgtY3JfoXpbspqBkwH
QhWNc8M/T5S7H+cg+N3J4JWrlgHJW+LoRfDCN5RtjLl/SLBfpuCG5mqUZ8wMOfsY
8HvIa9sQtRzMUo9HhrT6WbQcTncTHZDMUgv8d9YkkEyO6GVqjKcDLrjjGV4s9cm3
YLtHb4XUeHxSRIJ341rwBV+hK5MDT8RUxLuOj9zxMV2Gtp1hnkmKLjezRkTa32E2
9JZOvLYbIyG0JyA4VT3hWnh78ib9N1rKYONWtnh00qgQeIMt+7fKZcZ3ARbeLuxt
2gExuUzdo4kSxnPMiocYppNRueYcEskM6ZVD9k01Xq1t6F0sz3T8JK5SD+EpLaCz
4jZWu32rp/VG5ap9Y3BKV7rGLZemLQvmOxgVf9JnPeOdOVh8Vm4Kleq3x27gaMyB
nZVcyN99R9BomIKEawivYWdJeMLx4mLzgnBACgx3/DJWPLASixM1ncF7I8vfMepE
eKa2j2luiQc1Mg/iLFDqgFAB6+sipHu7x43lHOZvRYoeKTrVSgchEtWvvnn8+I9O
v754ZGtFl6/34v88L4Ak
=NiG+
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
