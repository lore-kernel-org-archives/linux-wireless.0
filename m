Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:52892 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbcBFBCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 20:02:50 -0500
Received: from [192.168.52.2] (unknown [24.69.201.142])
	by gw.sieb.net (Postfix) with ESMTPSA id 8BADE20E0D
	for <linux-wireless@vger.kernel.org>; Fri,  5 Feb 2016 16:54:40 -0800 (PST)
Subject: Re: BCM43142 doesn't work
References: <56B53603.4080905@sieb.net>
 <CACna6rxJFo-rtUP6g3LGn-e3fwF==OkVtBo41iLxKoWY=ETYRA@mail.gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Samuel Sieb <samuel@sieb.net>
Message-ID: <56B5444D.5070103@sieb.net> (sfid-20160206_020254_042835_F351FE3E)
Date: Fri, 5 Feb 2016 16:54:37 -0800
MIME-Version: 1.0
In-Reply-To: <CACna6rxJFo-rtUP6g3LGn-e3fwF==OkVtBo41iLxKoWY=ETYRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2016 04:41 PM, Rafał Miłecki wrote:
> On 6 February 2016 at 00:53, Samuel Sieb <samuel@sieb.net> wrote:
>> However, what happens is:
>> Feb 04 11:55:50 localhost kernel: bcma: bus0: Found chip with id 43142, rev
>> 0x01 and package 0x08
>> Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 0 found: ChipCommon
>> (manuf 0x4BF, id 0x800, rev 0x28, class 0x0)
>> Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 1 found: IEEE 802.11
>> (manuf 0x4BF, id 0x812, rev 0x21, class 0x0)
>> Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 2 found: PCIe (manuf
>> 0x4BF, id 0x820, rev 0x16, class 0x0)
>> Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 3 found: UNKNOWN (manuf
>> 0x43B, id 0x368, rev 0x00, class 0x0)
>> Feb 04 11:55:50 localhost kernel: bcma: bus0: Bus registered
>
> Which means bcma (bus!) supports BCM43132. It detects bus (!) devices
> correctly and registers them. There is no driver supporting wireless
> device found on this chipset.
>
Thank you, that makes sense. So I will need a 3rd party driver after 
all.  Unfortunately, the wireless chipset is not one of the specs listed 
in most stores.

