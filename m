Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:60013 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbXKNNCY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 08:02:24 -0500
Received: from rufsun5.fkie.fgan.de ([128.7.2.5] helo=mailhost.fgan.de)
	by mailguard.fgan.de with esmtp (Exim 4.63)
	(envelope-from <Rogge@fgan.de>)
	id 1IsHAp-000409-B4
	for linux-wireless@vger.kernel.org; Wed, 14 Nov 2007 13:16:51 +0100
Received: from mailserv.lorien.fkie.fgan.de ([128.7.90.101])
	by mailhost.fgan.de with esmtp (Exim 4.67 #7 (Solaris MB))
	id 1IsHAp-00064c-4P
	for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 13:16:51 +0100
From: Henning Rogge <rogge@fgan.de>
To: linux-wireless@vger.kernel.org
Subject: Virtual wireless network card for mac80211
Date: Wed, 14 Nov 2007 13:16:50 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711141316.50393.rogge@fgan.de> (sfid-20071114_130227_204342_2DDA04DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm looking for a way to simulate a ieee802.11 card on a linux system. Is 
there an equivalent for tun/tap for the mac80211 layer, so I can just send 
the communication with a wireless device back to userspace (and data from 
userspace into the wireless stack) ?

Henning Rogge
