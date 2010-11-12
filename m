Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lugano1.hostireland.com ([72.32.223.205]:46373 "EHLO
	lugano.hostireland.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750764Ab0KLFrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 00:47:03 -0500
From: "raghunath" <raghunath@airvod.com>
To: "'Luciano Coelho'" <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
References: <004701cb8191$e82c75e0$b88561a0$@com>	 <AANLkTikZD_1DUqkxQyGSLdaQS01Qg15+_TDkW3QuRuOt@mail.gmail.com>	 <1289476604.1606.36.camel@powerslave> <005101cb81af$f1e75280$d5b5f780$@com> <1289488173.1606.58.camel@powerslave>
In-Reply-To: <1289488173.1606.58.camel@powerslave>
Subject: RE: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36
Date: Fri, 12 Nov 2010 11:16:56 +0530
Message-ID: <000001cb822d$067f8230$137e8690$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using firmware version "wl1271: firmware booted (Rev 6.1.0.0.343)"

Raghu


-----Original Message-----
From: Luciano Coelho [mailto:luciano.coelho@nokia.com] 
Sent: Thursday, November 11, 2010 8:40 PM
To: ext raghunath
Cc: linux-wireless@vger.kernel.org
Subject: RE: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36

On Thu, 2010-11-11 at 15:51 +0100, ext raghunath wrote:
> I applied the patch which u have mentioned, but there is no change.

Hmmm... Too bad.  It looked like the same problem that was fixed in that
patch, but apparently it wasn't.

Which firmware version are you using? You can find that out by checking
the dmesg (grep for "firmware booted").

-- 
Cheers,
Luca.

