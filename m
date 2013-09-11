Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53538 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3IKScE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 14:32:04 -0400
Received: from [192.168.2.100] ([79.218.107.113]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0LanoO-1VmGCI132e-00kR8a for
 <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 20:32:02 +0200
Message-ID: <5230B721.40104@rempel-privat.de> (sfid-20130911_203208_520996_4FAB4A88)
Date: Wed, 11 Sep 2013 20:32:01 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: correct way to reduce traffic needed for LED triggering
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

what is correct way to reduce IO needed for LED blinking? I did it with 
ieee80211_queue_delayed_work(.., &priv->led-work, msecs_to_jiffird(HZ));

or are there other way to regulate it?
-- 
Regards,
Oleksij
