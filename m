Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53375 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbYG3Wva (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 18:51:30 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KOKW0-0007tY-6u
	for linux-wireless@vger.kernel.org; Wed, 30 Jul 2008 22:51:28 +0000
Received: from ppp91-122-81-226.pppoe.avangarddsl.ru ([91.122.81.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 22:51:28 +0000
Received: from dbaryshkov by ppp91-122-81-226.pppoe.avangarddsl.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 22:51:28 +0000
To: linux-wireless@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Driver for the FullMAC card
Date: Wed, 30 Jul 2008 22:51:20 +0000 (UTC)
Message-ID: <g6qr98$q28$2@ger.gmane.org> (sfid-20080731_005133_979537_2A17D336)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'd like to work on the Prism2 USB driver (currently maintained as a part of
wlan-ng project) to be able to push it into mainline. The card itself is
a FullMAC card. Where should I start? What parts of 802.11 stacks/API
should I use? There is plenty of information regarding SoftMAC drivers,
but no clear pointers for developing drivers for the FullMAC cards.

-- 
With best wishes
Dmitry


