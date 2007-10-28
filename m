Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43582 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXJ1Jtb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 05:49:31 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id CBCB415125
	for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2007 10:49:29 +0100 (CET)
From: Andreas Schwab <schwab@suse.de>
To: linux-wireless@vger.kernel.org
Subject: B43: Badness at drivers/net/wireless/b43/dma.c:1095
Date: Sun, 28 Oct 2007 10:49:29 +0100
Message-ID: <jeir4rpo0m.fsf@sykes.suse.de> (sfid-20071028_094936_383525_CDEA39CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm getting this badness with b43 on my iBook during network scan,
because cookie is zero in parse_cookie.  Sometimes the last message
before the badness is "b43-phy0 ERROR: PHY transmission error".  This i=
s
a 4318:

b43-phy0: Broadcom 4318 WLAN found
b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
