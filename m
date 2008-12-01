Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:37358 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbYLAXUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 18:20:32 -0500
Message-ID: <4934713E.8060500@lwfinger.net> (sfid-20081202_002037_180953_B39FE574)
Date: Mon, 01 Dec 2008 17:20:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problem with rtl8187
References: <4933EEBC.3030105@gmail.com>
In-Reply-To: <4933EEBC.3030105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mart=EDn Ernesto Barreyro wrote:
> Hello I'm using the latest revision of compat wireless on a Debian Le=
nny
> with a 2.6.27.7 kernel downloaded from kernel.org.
>=20
> uname -ra
> Linux notebook 2.6.27.7 #1 SMP Thu Nov 27 15:12:29 ARST 2008 i686 GNU=
/Linux
>=20
> My notebook is fabricated in Argentina by Bangh=F3. It has a rtl8187 =
usb
> wireless card.
>=20
> lsusb | grep Realtek
>=20
> Bus 001 Device 003: ID 0bda:8187 Realtek Semiconductor Corp. RTL8187
> Wireless Adapter
>=20
> The thing is that when I'm downloading something using a bit torrent
> client the connection falls. Network Manager (v0.7.0) still shows the
> connection as active showing the intensity of the signal, but I can't
> use the network.
> I've search in the syslogs, messages and daemon.log and I can't find
> anything unusual. At least form me.
>=20
> When the connection stops I've to reload the driver with
>=20
> rmmod rtl8187
> modprobe rtl8187
>=20
> I'm a little far from de AP but it becames stable at 11Mb/s and it on=
ly
> falls with the bit torrent client.
> The time it takes to fall is radom, and sometimes it happens after 10
> minutes less or more.
> I've tried to limit the torrent bitrate to 100KB/s and 80 KB/s and
> nothing. Also tried to use a 5.5Mb/s connection to the Ap, but nothin=
g
> improves.

I have had the driver fail for my RTL8187B, but it usually takes 18-24 =
hours. It
is good to know that a torrent client makes it happen more frequently. =
Perhaps I
can capture the wireless packets and see where it fails.

Thanks for your report,

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
