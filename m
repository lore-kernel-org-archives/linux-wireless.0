Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([204.127.217.103]:58725 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZGAP2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 11:28:32 -0400
Message-ID: <4A4B80AB.6090307@lwfinger.net>
Date: Wed, 01 Jul 2009 10:28:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ssb: Add support for 4318E
References: <4a4ada7f.oItwGXurq7WMW+HE%Larry.Finger@lwfinger.net> <200907011517.34061.mb@bu3sch.de>
In-Reply-To: <200907011517.34061.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 01 July 2009 05:39:43 Larry Finger wrote:
>> From: Clyde McPherson <ccmcphe@verizon.net>
>>
>> Added support for the Broadcom 4318E chipset on PCMCIA/CF cards. The 
>> 4318E can do 802.11A/B/G, only B and G mode are supported in b43.
>>
>> Signed-off-by: Clyde McPherson <ccmcphe@verizon.net>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> ack
> 

Cc: Stable <stable@vger.kernel.org>

John,

I forgot the above line in both the b43 and ssb patches.

Larry

