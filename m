Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:51823 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbZFGWkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 18:40:03 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MDR22-0008Et-L0
	for linux-wireless@vger.kernel.org; Sun, 07 Jun 2009 22:40:03 +0000
Received: from 175-147-19-190.fibertel.com.ar ([175-147-19-190.fibertel.com.ar])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 22:40:02 +0000
Received: from agfcpc1 by 175-147-19-190.fibertel.com.ar with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 22:40:02 +0000
To: linux-wireless@vger.kernel.org
From: Fabian <agfcpc1@hotmail.com>
Subject: compat-wireless-2009-06-05.tar.bz2 ath9k.h:469: error: the field =?utf-8?b?4oCYb3Bz4oCZ?= have incomplete type
Date: Sun, 7 Jun 2009 22:33:42 +0000 (UTC)
Message-ID: <loom.20090607T221436-196@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for http://aircrack-ng.org/doku.php?id=zd1211rw-mac80211

I need download:

http://wireless.kernel.org/download/compat-wireless-2.6/
http://patches.aircrack-ng.org/zd1211rw_inject_2.6.26.patch
http://patches.aircrack-ng.org/mac80211_2.6.28-rc4-wl_frag+ack_v3.patch

but compat-wireless-2009-06-05.tar.bz2
and
compat-wireless-old-2009-06-05.tar.bz2

have error
ath9k.h:469: error: el campo ‘ops’ tiene tipo de dato incompleto
ath9k.h:469: error: the field ‘ops’ have incomplete type


I compiled with ubuntu 9.04

But I havent error with
compat-wireless-2009-05-30.tar.bz2  this work fine

Thank you
Fabian

