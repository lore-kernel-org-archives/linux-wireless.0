Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56602 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab1GEHkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 03:40:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qe0En-0002Of-4s
	for linux-wireless@vger.kernel.org; Tue, 05 Jul 2011 09:40:05 +0200
Received: from 130.233.194.206 ([130.233.194.206])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 09:40:05 +0200
Received: from swaminathanvasanth.r by 130.233.194.206 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 09:40:05 +0200
To: linux-wireless@vger.kernel.org
From: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Subject: Automatic channel selection implementation of ath9k driver in Access point with openwrt Firmware for Netgear WNDR3700
Date: Tue, 5 Jul 2011 07:31:26 +0000 (UTC)
Message-ID: <loom.20110705T092928-27@post.gmane.org> (sfid-20110705_094009_722654_3C9E2AC2)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Friends,

 Hope all are doing good. I have a doubt regarding dynamic channel allocation
for atheros ath9k. I am currently trying to find out the channels used by the
nearby Access Points during the boot phase.
 
 I came to know that some are working in the same mainly on hostapd.

http://marc.info/?l=linux-wireless&m=130624133910615&w=2

I am trying to do the same with ath9k driver. Is there any working on the same
or having any experience of it?
 
If so i would like to share, test it and contribute.

Awaiting your kind reply.



