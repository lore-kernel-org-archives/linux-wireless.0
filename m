Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbYEZUFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 16:05:53 -0400
Message-ID: <483B181F.3010802@scherping.de> (sfid-20080526_220556_973924_5B78DC29)
Date: Mon, 26 May 2008 22:05:51 +0200
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath5k: 10 MHz channels?
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello list!

I have been testing ath5k with some different Atheros devices (Cardbus bg, MiniPCI HighPower abg, MiniPCI HighPower a - exact models available if needed) and found that it works quite well now. Test systems were running Debian 4.0 with Kernel 2.6.22 from backports and compat-wireless 2008-05-17.

While using arbitrary channels worked quite well (got ad-hoc working at 6.1 GHz - in development lab, so no legal problems with that) I do miss the possibility to switch to 10 MHz wide channel operation as it is possible with MadWifi and needed for some 11j modes.

Are there any hints how this might be possible to enable? I can provide analysis of the systems running with MadWifi and 10 MHz channels if needed - just direct me to the right tools ;-)

Thanks in advance for any help!

Richard
