Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:18655 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752331AbYLFMps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 07:45:48 -0500
Received: from unknown (HELO loke.fish.not) ([83.233.19.199])
          (envelope-sender <spamcan1@abrasax.se>)
          by smtp.bredband2.net (qmail-ldap-1.03) with SMTP
          for <linux-wireless@vger.kernel.org>; 6 Dec 2008 12:50:34 -0000
Received: from loke.fish.not (localhost [127.0.0.1])
	by loke.fish.not (Postfix) with ESMTP id D23C812B94
	for <linux-wireless@vger.kernel.org>; Sat,  6 Dec 2008 13:45:42 +0100 (CET)
Date: Sat, 6 Dec 2008 13:45:42 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as
 root
Message-ID: <20081206134542.05cd9664@loke.fish.not> (sfid-20081206_134606_815468_365559F2)
In-Reply-To: <20081206113406.734f1d94@loke.fish.not>
References: <20081206113406.734f1d94@loke.fish.not>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 6 Dec 2008 11:34:06 +0100 Mats Johannesson wrote:
> 
> As the subject says, 2.6.28-rc7-wl git pulled Dec 6 exhibits a kernel
> panic when doing "iwlist ath0 scan" as root under the ath9k driver.
> Machine dead, panic LED blinking.
> 
> Scan as normal user is OK.

Ick! Panic as normal user as well when using the graphical "Wicd
Manager" to Refresh (ie scan). Possibly it does its thing as root?

First panic was as root on a fresh kernel without any graphics driver
(plain terminal). Second try was as a normal user in said plain
terminal - was OK. Logged out and in as root to scan -> panic.

Installed graphics driver and ran as normal user under X. Wicd handles
the wpa_supplicant etc. Scanning in an xterm as myself was OK. Later
tried the Wicd Manager Refresh thing out of curiosity. Panic.

/Mats
