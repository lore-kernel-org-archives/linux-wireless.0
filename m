Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:42579 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3LAAJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 19:09:41 -0500
Received: by mail-la0-f48.google.com with SMTP id n7so7437016lam.7
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 16:09:39 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 1 Dec 2013 01:09:38 +0100
Message-ID: <CAEk6gTCqKgt9zX0Xs147GYfxDw2Ex-1NkG4KZ_m_pdf1M8eDLw@mail.gmail.com> (sfid-20131201_010959_948340_FEBB7608)
Subject: multi-wiphy (virtual radios that can be used with multiple channels)
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: linux-wireless@vger.kernel.org,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>, j@w1.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
can somebody please explain in some more details this possibility of
ath9k driver, mentioned here: http://lwn.net/Articles/321690/ and
specially here:
http://osdir.com/ml/linux-wireless/2009-03/msg00090.html in these
patches signed-off by Jouni.

Does this means that ath9k devices can be put in AP and STA modes
simultaneously (one virtual interface for each) over different
channels?

I am looking to solve this problem: I want to have always present AP
for user settings that I bring on boot, so I give it some
pre-configured channel. Via this AP user will configure other
interface in STA mode to connect to home network. However, this home
network can be over any channel, very potentially different of the one
I have chosen for AP.

Would these patches allow something like this, and how they should be
used (I saw here some use case -
http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg03617.html,
but not clear enough)?

Best regards,
Drasko
