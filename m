Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:47673 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936463Ab0B1TnZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 14:43:25 -0500
Message-ID: <4B8AC78C.80505@polymtl.ca>
Date: Sun, 28 Feb 2010 14:44:12 -0500
From: William Bourque <william.bourque@polymtl.ca>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com> 	<201002271708.29817.mb@bu3sch.de> <4B894A61.1070302@lwfinger.net> 	<69e28c911002271145s590df31en9d2f8b2c47932451@mail.gmail.com> 	<4B899DA3.4030100@lwfinger.net> <69e28c911002271534o8cab111vf7fcc1b93b6c4b47@mail.gmail.com> 	<a221c0101002271542o5d928e56n8a22602860aeb761@mail.gmail.com> 	<69e28c911002271544y62c93255k8a6dbb0adb2b5928@mail.gmail.com> 	<20100228001655.4c9fd9ce@boulder.homenet> <4B8AAF42.8000602@polymtl.ca> <69e28c911002281042g15808a2cm81bd9528a30d2f85@mail.gmail.com>
In-Reply-To: <69e28c911002281042g15808a2cm81bd9528a30d2f85@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> New test patch attached.
> 
> Please CC linux-wireless@vger.kernel.org on further e-mails,
> bcm43xx-dev appears to be having problems.
> 

Hmm... I don't know if it is only coincidence, but this one seems to 
help somehow.

The driver raised the DMA error again, but instead of being as soon as I 
brought up the interface, I had to stresstest (to transfert a file at 
full speed from my LAN) to make it happens. Before that I was able to 
DMA normally (loading web page ...).

- William
