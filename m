Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49986 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2FKWKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 18:10:02 -0400
Received: by wibhn6 with SMTP id hn6so3424780wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 15:10:00 -0700 (PDT)
Message-ID: <4FD66CB6.6080606@gmail.com> (sfid-20120612_001007_450048_75BB9B1E)
Date: Tue, 12 Jun 2012 00:09:58 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] rt2x00: missing devices/chips
References: <4FBBF88F.5060508@gmail.com> <CAGXE3d-GJDPN70AHnYRBXhNdfXg2quL1xCYwJ-VoSNjhHHZDhQ@mail.gmail.com>
In-Reply-To: <CAGXE3d-GJDPN70AHnYRBXhNdfXg2quL1xCYwJ-VoSNjhHHZDhQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2012 01:35 PM, Helmut Schaa wrote:

> On Tue, May 22, 2012 at 10:35 PM, Xose Vazquez Perez
> <xose.vazquez@gmail.com> wrote:
>> Those were my final patches, from now on MediaTek Inc. guys
>> should take over it.
>
> That would indeed be nice, let's see what the future brings.
>
> However, thanks a lot for all your contributions!
> Helmut

missing in rt2800pci :

0x1814, 0x3290   RT3290LE 802.11b/g/n Wireless LAN Adapter
0x1814, 0x359f   RT3592   802.11a/b/g/n 2x2 WiFi Adapter
0x1814, 0x5360   RT5360   (D-Link DWA-525 Wireless N 150 Desktop PCI Adapter A2) only in linux-next
0x1814, 0x5592   RT5592   (ASUS PCE-N53 300Mbps 11n Dual band Wireless LAN PCI-E Card)
