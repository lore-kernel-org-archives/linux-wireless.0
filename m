Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:52498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbXJQThd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 15:37:33 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 4CB19150C4
	for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2007 21:37:32 +0200 (CEST)
From: Andreas Schwab <schwab@suse.de>
To: linux-wireless@vger.kernel.org
Subject: b43: cannot set channel to 12
Date: Wed, 17 Oct 2007 21:37:31 +0200
Message-ID: <jey7e1leh0.fsf@sykes.suse.de> (sfid-20071017_203738_709049_9A5F2A11)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The b43 driver in current wireless-2.6 cannot set the channel to 12:

# iwconfig wlan0 chan 12
Error for wireless request "Set Frequency" (8B04) :
    SET failed on device wlan0 ; Invalid argument

iwlist still lists the APs on channels 12 and 13.

This is a 4318 in a iBook G4, using firmware version 410.2160.

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
