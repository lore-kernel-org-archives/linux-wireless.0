Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mirapoint21.brutele.be ([212.68.199.158]:30018 "EHLO
	mirapoint21.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1CFU4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 15:56:47 -0500
Message-ID: <4D73F506.50609@tvcablenet.be>
Date: Sun, 06 Mar 2011 21:56:38 +0100
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 11/11] rtlwifi: rtl8192se: Modify rtlwifi routines to
 handle rtl8192se and add Makefile and Kconfig
References: <4d732b88.lM+a0Gg928N+S/xO%Larry.Finger@lwfinger.net> <4D73EB12.3040102@tvcablenet.be> <4D73F209.8050406@lwfinger.net>
In-Reply-To: <4D73F209.8050406@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 06/03/11 21:43, Larry Finger a écrit :
> On 03/06/2011 02:14 PM, François Valenduc wrote:
>>>
>> Hello,
>>
>> It seems this patch is the same as the previous one (Merge routines
>> trx.c and trx.h for RTL8192SE). It doesn't add a Makefile and doesn't
>> contain KConfig entries.
>>
>> François Valenduc
>
> Yes, I messed up my sending script. The correct patch now submitted.
>
> Larry
>
Sorry to annoy you again but either I am doing something wrong or this
new patch doesn't apply on top of the 10 first patches. There seems to
be problems in fuse.c, pci.c and core.c (all in
drivers/net/wireless/rtlwifi).

François

François


