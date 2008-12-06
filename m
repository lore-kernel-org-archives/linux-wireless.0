Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:7920 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751947AbYLFKks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 05:40:48 -0500
Received: from unknown (HELO loke.fish.not) ([83.233.19.199])
          (envelope-sender <spamcan1@abrasax.se>)
          by smtp.bredband2.net (qmail-ldap-1.03) with SMTP
          for <linux-wireless@vger.kernel.org>; 6 Dec 2008 10:31:14 -0000
Received: from loke.fish.not (localhost [127.0.0.1])
	by loke.fish.not (Postfix) with ESMTP id BB5E312B8F
	for <linux-wireless@vger.kernel.org>; Sat,  6 Dec 2008 11:34:06 +0100 (CET)
Date: Sat, 6 Dec 2008 11:34:06 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: linux-wireless@vger.kernel.org
Subject: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as root
Message-ID: <20081206113406.734f1d94@loke.fish.not> (sfid-20081206_114124_771926_E4323BE1)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


As the subject says, 2.6.28-rc7-wl git pulled Dec 6 exhibits a kernel
panic when doing "iwlist ath0 scan" as root under the ath9k driver.
Machine dead, panic LED blinking.

Scan as normal user is OK.

/Mats
