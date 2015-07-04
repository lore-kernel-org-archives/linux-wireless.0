Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36539 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbbGDCPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 22:15:53 -0400
Received: by wguu7 with SMTP id u7so99499685wgu.3
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jul 2015 19:15:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55965CF8.20208@thinktube.com>
References: <CAFSTUk6UasnV4P3B1TR7kSx1ToQTC+PC2hU6PynDBWJ3ALJzyg@mail.gmail.com>
	<55965CF8.20208@thinktube.com>
Date: Sat, 4 Jul 2015 11:15:52 +0900
Message-ID: <CAMArcTUvpBpTB=woMiY2mET+KOUKNLvY53Exb1F6vB+aztq6Lw@mail.gmail.com> (sfid-20150704_041907_093563_A6AC86F6)
Subject: Re: mesh support on rtl8192cu
From: Taehee Yoo <ap420073@gmail.com>
To: Bruno Randolf <br1@thinktube.com>
Cc: Richard Palethorpe <richard@lm-technologies.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-07-03 18:59 GMT+09:00 Bruno Randolf <br1@thinktube.com>:
> On 07/03/2015 10:34 AM, Richard Palethorpe wrote:
>> Hello Taehee,
>>
>> I have been experimenting with MESH mode on kernel 4.0.7. It is
>> sending beacons out, but is unable to establish a connection.
>>
>> I have two rtl8192cu based dongles connected to identical VMs and am
>> using the following commands to set up the mesh:
>>
>> iw dev wls160u2 set type mesh
>> ip addr add 192.168.2.1/24 broadcast 192.168.2.255 dev wls160u2
>> ip link set wls160u2 up
>> iw dev wls160u2 mesh join lmmesh
>>
>> Running 'iw dev wls160u2 mpath dump' produces no results and there is
>> nothing regarding mesh in dmesg. I can't find any other information on
>> mesh with rtl8192cu other than the patch which you submitted.
>>
>> I am wondering if it does work, but there is a step I am missing or if
>> something is wrong with the code?
>
> I don't know about this 'mesh' mode, but I have noted problems in ad-hoc
> mode with this chipset and driver. The problem seems to be that ARP
> replies are not sent on the air... Not sure what the reason is or if
> it's possible to fix it in the driver, but my conclusion for now is that
> this device is unusable for ad-hoc mode. Similar problems may exist for
> mesh?
>
> bruno
>

I don't know about a mesh network.
But, according to my ping test result, 'mpath dump' shows ping traffics.

Did you generate any traffics?
