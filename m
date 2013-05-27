Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51623 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3E0IzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 04:55:25 -0400
Message-ID: <1369644920.8229.10.camel@jlt4.sipsolutions.net> (sfid-20130527_105528_855950_86665D88)
Subject: Re: [PATCHv2] mac80211: Allow single vif mac address change with
 addr_mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
	Alessandro Lannocca <alessandro.lannocca@gmail.com>,
	Bruno Randolf <br1@thinktube.com>
Date: Mon, 27 May 2013 10:55:20 +0200
In-Reply-To: <1369644189-13874-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20130527_104220_284174_9B6C91AE)
References: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
	 <1369644189-13874-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20130527_104220_284174_9B6C91AE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-27 at 10:43 +0200, Helmut Schaa wrote:
> When changing the MAC address of a single vif mac80211 will check if
> the new address fits into the address mask specified by the driver.
> This only needs to be done when using multiple BSSIDs. Hence, check
> the new address only against all other vifs.
> 
> Also fix the MAC address assignment on new interfaces if the user
> changed the address of a vif such that perm_addr is not covered by
> addr_mask anymore.
> 
> Resolves:
> https://bugzilla.kernel.org/show_bug.cgi?id=57371

Applied for 3.10, thanks.

johannes

