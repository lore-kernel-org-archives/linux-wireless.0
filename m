Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaweb11.services.sfr.fr ([93.17.128.28]:30278 "EHLO
	smtp11.services.sfr.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753061Ab2AaO5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:57:36 -0500
Date: Tue, 31 Jan 2012 15:57:35 +0100 (CET)
From: Milan Bouchet-Valat <nalimilan@club-internet.fr>
Reply-To: Milan Bouchet-Valat <nalimilan@club-internet.fr>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <1471699.185047.1328021855281.JavaMail.www@wsfrf1118> (sfid-20120131_155740_143013_805EDDCB)
In-Reply-To: <13367957.180704.1328018261479.JavaMail.www@wsfrf1118>
References: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232>
 <4F227784.10309@broadcom.com> <1327660003.21888.14.camel@milan>
 <4F228C76.2010109@broadcom.com>
 <13367957.180704.1328018261479.JavaMail.www@wsfrf1118>
Subject: Re: Re: BCM4313 keeps disconnecting with brcmsmac and multiple APs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mardi 31 janvier 2012 à 15:44 +0100, Arend van Spriel a écrit :
> Could you provide another log trace in which it goes wrong.
Sure. Attached is /var/log/messages from the point where I resumed my computer this afternoon: you can see that the disconnection issue I described happened at 14:16. Then the NetworkManager auth dialog showed up twice, and I reloaded brcmsmac twice before it reconnected correctly.

> I am
> wondering whether it attempts to connect to a different AP or not. I
> assume each AP has the same SSID and security configration, right?
Same security configuration, yes (WPA2 and WPA1). If by SSID you mean ESSID, yes; but isn't it what defines a wireless network? I must be missing something.


Regards
