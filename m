Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:28426 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0KKPJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 10:09:37 -0500
Subject: RE: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext raghunath <raghunath@airvod.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <005101cb81af$f1e75280$d5b5f780$@com>
References: <004701cb8191$e82c75e0$b88561a0$@com>
	 <AANLkTikZD_1DUqkxQyGSLdaQS01Qg15+_TDkW3QuRuOt@mail.gmail.com>
	 <1289476604.1606.36.camel@powerslave> <005101cb81af$f1e75280$d5b5f780$@com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 17:09:33 +0200
Message-ID: <1289488173.1606.58.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 15:51 +0100, ext raghunath wrote:
> I applied the patch which u have mentioned, but there is no change.

Hmmm... Too bad.  It looked like the same problem that was fixed in that
patch, but apparently it wasn't.

Which firmware version are you using? You can find that out by checking
the dmesg (grep for "firmware booted").

-- 
Cheers,
Luca.

