Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49804 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526Ab2AIWSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 17:18:39 -0500
Received: by obcwo16 with SMTP id wo16so4722675obc.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 14:18:38 -0800 (PST)
Message-ID: <4F0B67BA.20207@lwfinger.net> (sfid-20120109_231843_058423_88A3AEFC)
Date: Mon, 09 Jan 2012 16:18:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	Abimanyu Gottumukkala <me@abimanyu.in>,
	linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>
Subject: Re: BCM43231
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com> <CACna6rzNrFWBJ+n3n9wrnP_Gi3LKCWt+o1Gs38_EjkMgG_k8vg@mail.gmail.com>
In-Reply-To: <CACna6rzNrFWBJ+n3n9wrnP_Gi3LKCWt+o1Gs38_EjkMgG_k8vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 02:12 PM, Rafał Miłecki wrote:
> 2011/12/30 Abimanyu Gottumukkala<me@abimanyu.in>:
>> Does any one have status or any info on BCM43231 USB drivers?
>
> I've received my WNA3100, 0846:9020 (maybe BCM43231, can't confirm).
>
> It works with ndiswrapper and bcmwlhigh6, I can scan and even connect
> to my WPA2 network.
>
> Unfortunately I've no idea what hardware is this. I've dumped
> ndiswrapper USB operations but they don't tell me a single thing.
> Initialization is represented by only ~1000 lines in dumps and I've
> connected in next ~1500 lines of USB dump. I've been using "usbmon" to
> dump traffic.

The evidence points to some kind of Broadcom chip. The USB data base says that 
an ID of "0846:9020" is a "WNA3100(v1) Wireless-N 300 [Broadcom BCM43231]". In 
addition, the Windows driver name of bcmwlhigh6 indicates a BroadCoM WL driver 
of some sort. Given the relatively small amount of initialization traffic, it 
must be a fullmac device that likely does not need external firmware.

I remember seeing some mail about the Broadcom guys working on a Linux driver 
for a USB fullmac device. Is this the one? (I added Arend to the Cc.)

Larry
