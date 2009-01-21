Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:43278 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZAUR3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 12:29:44 -0500
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>, kyle@infradead.org,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Message-Id: <FBC507F3-1CD3-4AD7-9A6D-4D61A5B63DF0@ing.unibs.it> (sfid-20090121_182948_311829_9EAD5448)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: bcm43xx-dev@lists.berlios.de
In-Reply-To: <200901161612.24288.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [b43] opensource firmware
Date: Wed, 21 Jan 2009 18:29:40 +0100
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <496F5D4F.3020805@lwfinger.net> <65BB63A7-75ED-464D-AD81-E34F3AD560BE@ing.unibs.it> <200901161612.24288.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

we just made available a new opensource firmware version, download at http://www.ing.unibs.it/openfwwf

New features:
- initvals source code added, initvals files are encoded by make process
- firmware is now recognized as opensource, though still as version  
351 (old format). Firmware's date switched to FFFF
- watchdog implemented

Tested with kernel 2.6.29-rc2-wl.

Cheers,
-FG
