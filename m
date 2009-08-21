Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:58262 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZHUXvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 19:51:20 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Joerg Albert <jal2@gmx.de>
Subject: Re: [RFT] ar9170: use eeprom's frequency calibration values
Date: Sat, 22 Aug 2009 01:51:19 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200908212252.41053.chunkeey@web.de> <4A8F2F71.1010100@gmx.de>
In-Reply-To: <4A8F2F71.1010100@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908220151.19792.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 August 2009 01:36:17 Joerg Albert wrote:
> On 08/21/2009 10:52 PM, Christian Lamparter wrote:
> > This patch adds some more bits from the vendor driver, which
> > are supposed to help users with the one-stage/openfw firmwares.
> 
> The otus driver sets phy registers 672-703 only for the one-stage firmware -
> hal/hpmain.c, line 3445:
> 
>         #ifndef ZM_OTUS_LINUX_PHASE_2
>         reg_write(regAddr + i, val);  /* CR672 */
>         #endif
> 
> Are you sure it doesn't hurt with the two-stage firmware?
no idea, that's why I ask requested input, instead of posting a patch +
sob right away.

so far, I haven't heard of or experienced any regressions or anomalies.
Do you already have comments or complains? :)

Regards,
	Chr
