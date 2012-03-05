Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:47488 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab2CEBeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 20:34:12 -0500
Date: Sun, 04 Mar 2012 20:32:59 -0500 (EST)
Message-Id: <20120304.203259.81092010167419901.davem@davemloft.net> (sfid-20120305_023442_640469_FD888BB8)
To: wey-yi.w.guy@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com
Subject: Re: [PATCH 001/101] iwlwifi: move iwl_clear_driver_stations to user
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330889395-533-2-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
	<1330889395-533-2-git-send-email-wey-yi.w.guy@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


You seriously cannot queue up this work all at one time.

It is absolutely unreasonable to burdon the community with having to
review a hundred patches at one time.

You must split these submissions down into smaller groups, say groups
of 10 or so patches.

Also consider what if one patch in the first ten has a problem, and
this causes conflicts with the next 90 patches?
