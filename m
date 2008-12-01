Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:46696 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYLAODp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 09:03:45 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2677946wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 06:03:44 -0800 (PST)
Message-ID: <4933EEBC.3030105@gmail.com> (sfid-20081201_150357_869143_3D076463)
Date: Mon, 01 Dec 2008 12:03:40 -0200
From: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problem with rtl8187
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello I'm using the latest revision of compat wireless on a Debian Lenn=
y=20
with a 2.6.27.7 kernel downloaded from kernel.org.

uname -ra
Linux notebook 2.6.27.7 #1 SMP Thu Nov 27 15:12:29 ARST 2008 i686 GNU/L=
inux

My notebook is fabricated in Argentina by Bangh=F3. It has a rtl8187 us=
b=20
wireless card.

lsusb | grep Realtek

Bus 001 Device 003: ID 0bda:8187 Realtek Semiconductor Corp. RTL8187=20
Wireless Adapter

The thing is that when I'm downloading something using a bit torrent=20
client the connection falls. Network Manager (v0.7.0) still shows the=20
connection as active showing the intensity of the signal, but I can't=20
use the network.
I've search in the syslogs, messages and daemon.log and I can't find=20
anything unusual. At least form me.

When the connection stops I've to reload the driver with

rmmod rtl8187
modprobe rtl8187

I'm a little far from de AP but it becames stable at 11Mb/s and it only=
=20
falls with the bit torrent client.
The time it takes to fall is radom, and sometimes it happens after 10=20
minutes less or more.
I've tried to limit the torrent bitrate to 100KB/s and 80 KB/s and=20
nothing. Also tried to use a 5.5Mb/s connection to the Ap, but nothing=20
improves.

Ah! my conection is using WPA Personal for authentication. My wireless=20
router is a CNet.

I've already tried with ndiswrapper and it doesn't worked.

Sorry about my english and if my description of the problem is not=20
useful. Please tell me what information you need.

Please help me! Thanks!
--=20
*Mart=EDn Ernesto Barreyro*
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
