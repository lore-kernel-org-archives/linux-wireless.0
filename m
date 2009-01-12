Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:55172 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZALPsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 10:48:52 -0500
Cc: Lorenzo Nava <navalorenx@gmail.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Message-Id: <2CB1EEC3-40EB-41D4-9A4C-E240359F05AA@ing.unibs.it> (sfid-20090112_164901_523230_F85592EE)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090112153949.GC31525@tuxdriver.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [b43] opensource firmware
Date: Mon, 12 Jan 2009 16:48:48 +0100
References: <200901091129.22708.mb@bu3sch.de> <200901091149.28683.mb@bu3sch.de> <9F70A0D3-6334-45FB-9DAF-263FE89C847E@ing.unibs.it> <200901091206.09736.mb@bu3sch.de> <AE7A4FD8-1728-4CE2-8CC7-DCE699C3B6C9@gmail.com> <20090112153949.GC31525@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 12, 2009, at 4:39 PM, John W. Linville wrote:

> On Sat, Jan 10, 2009 at 06:37:43PM +0100, Lorenzo Nava wrote:
>> Hello everybody,
>>
>> today I tried OpenFWWF with kernel 2.6.28 on a Siemens wifi device  
>> with
>> Broadcom 4306 chipset:
>>
>> BCM94306 802.11g (rev 03)
>> PHY: Analog 2, Type 2, Revision 2
>> Radio: Manuf 0x17F, Version 0x2050, Revision 2
>>
>> I did some tests and everything seems to work fine.
>>
>> I remember, once again, that OpenFWWF needs v480 initvals to work
>> properly, and was tested on 2.6.27-rc5 kernel.
>
> Any chance on getting a set of initvals packaged with the open source
> firmware?  That would allow distros like Fedora to package this...
>
> John
> -- 
> John W. Linville		Linux should be at the core
> linville@tuxdriver.com			of your literate lifestyle.
Yes, we have it now. Still testing as several values can be cut out.  
Posting ASAP.
Cheers.
-FG
