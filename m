Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1CISuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 13:50:10 -0500
Received: by wya21 with SMTP id 21so724485wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 10:50:09 -0800 (PST)
Message-ID: <4D77CA78.3080401@lwfinger.net>
Date: Wed, 09 Mar 2011 12:44:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	=?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
Subject: Re: Problem with BCM943224
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>	<4D77A06E.3050902@lwfinger.net>	<AANLkTinYp64QZ5o1-=xP_ehVhLPwDLR+gQnQk7MADHFA@mail.gmail.com>	<4D77AD18.60804@lwfinger.net>	<AANLkTingWDXtuxWtQwkVFbhOnfHmAPsp1KsyQWJcRBqR@mail.gmail.com>	<4D77B4B6.8030603@lwfinger.net> <AANLkTinEC5b6-vP_zc2RE2Juc8YFx8nkEK7isvQw+UVX@mail.gmail.com>
In-Reply-To: <AANLkTinEC5b6-vP_zc2RE2Juc8YFx8nkEK7isvQw+UVX@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2011 12:04 PM, Rafał Miłecki wrote:
>
> The only other solution I can see is to buy motherboard with mini PCIe
> slot. There are some *D410P* (BLKD410PT, BOXD410PT, BLKD410PTL,
> D410PT) and D510MO having such a slow (and Atom CPU.... :/). Kernel
> compilation would be disaster but I think I could live with that. Do
> you think such a boards would be compatible with Broadcom's cards?

I have a system with an Atom processor and one with an AMD 450 MHz CPU. I do not 
try to build kernels on either of them. I have their sources on a 2.4 GHz 
dual-core machine in an NFS-exported volume. I cross-build for i386 as the host 
is 64 bits and only do the "make modules_install install" on the target 
machines. It works quite well.

Larry


