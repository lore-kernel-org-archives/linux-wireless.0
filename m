Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out1.libero.it ([212.52.84.101]:45145 "EHLO
	cp-out1.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZETJzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 05:55:52 -0400
Received: from libero.it (192.168.17.15) by cp-out1.libero.it (8.5.107)
        id 4A07F3390091B386 for linux-wireless@vger.kernel.org; Wed, 20 May 2009 11:55:52 +0200
Date: Wed, 20 May 2009 11:55:52 +0200
Message-Id: <KJXSX4$879353F1086C26A62039759B06C868B9@libero.it>
Subject: mac80211: TDMA approach feasible?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
From: "ffileppo" <ffileppo@libero.it>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I was wondering if with mac80211 is now possible (and what effort is needed) to implement a TDMA approach. In particular I would like to: override 802.11 MPDU frame format, eliminate RTS/CTS exchange, eliminate automatic ACK and retransmission, eliminate virtual carrier sense (NAV), control PHY clear channel assessment and control transmission backoff.

I've read that mac80211 allows arbitrary packets to be injected down any Monitor Mode interface from userland but it is still not clear to me if it is possible to override some of the 802.11 MAC features.

Thank you,

Francesco

