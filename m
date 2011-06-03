Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:58665 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1FCXyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 19:54:43 -0400
Date: Fri, 03 Jun 2011 16:53:37 -0700 (PDT)
Message-Id: <20110603.165337.468496746139098019.davem@davemloft.net> (sfid-20110604_015507_401136_AB7095B0)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110603195254.GF2509@tuxdriver.com>
References: <20110603195254.GF2509@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 3 Jun 2011 15:52:54 -0400

> Here is a batch of fixes intended for 3.0 -- I guess I'll need to
> rename my tree eventually... :-)
> 
> Included are a libertas fix to ensure proper sequence number assignment
> on transmitted frames, an ath9k fix that propogates an earlier fix to a
> few more places,  a fix for a cfg80211 regression caused by some mesh
> code changes, a locking fix for the bluetooth l2cap code, a zd1211rw
> regression fix, a collection of small fixes for wl12xx, an iwl4965
> fix for a bad temperature check, an a device ID-related fix for iwlagn.
> 
> Please let me know if there are problems!

Pulled, thanks John.
