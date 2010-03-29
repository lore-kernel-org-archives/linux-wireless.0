Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0C2P1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 11:27:23 -0400
Date: Mon, 29 Mar 2010 17:27:21 +0200
From: Ralph Benzinger <t1@endlos.net>
To: linux-wireless@vger.kernel.org
Subject: Problems with hardware radio kill switch on Sony Vaio notebook
Message-ID: <20100329152721.GC6445@endlos.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

My Sony Vaio VPC-Y11S1E notebook has an Atheros AR9285 chip, which is
supported just fine by ath9k.  The notebook also has a physical radio
kill switch at the front that can be slid into one of two positions.
Alas, the rfkill tool shows wlan0 as "hard blocked: yes" for either
switch position.  Consequently, txpower is off, and wireless
networking cannot be activated.

Could you kindly indicate which part of the kernel would be
responsible for handling the radio kill switches -- cfg80211, ath9k,
sony-laptop, ...?  Are there any known fixes or workarounds?  I'm
using Kubuntu 9.10 with their stock kernel 2.6.31 and the wireless
backports modules right now, but tests with Kubuntu 10.4 Beta and
2.6.32 failed as well.

(Note that I cannot get ndiswrapper to work either, although it seems
to power on the wireless card.)

Thanks
Ralph
