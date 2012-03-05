Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab2CEBtg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 20:49:36 -0500
Subject: Re: [PATCH 001/101] iwlwifi: move iwl_clear_driver_stations to user
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com
In-Reply-To: <20120304.203259.81092010167419901.davem@davemloft.net>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1330889395-533-2-git-send-email-wey-yi.w.guy@intel.com>
	 <20120304.203259.81092010167419901.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Mar 2012 16:37:35 -0800
Message-ID: <1330907855.12612.50.camel@wwguy-huron> (sfid-20120305_024940_229842_E83DC4FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,


On Sun, 2012-03-04 at 20:32 -0500, David Miller wrote:
> You seriously cannot queue up this work all at one time.
> 
> It is absolutely unreasonable to burdon the community with having to
> review a hundred patches at one time.
> 
> You must split these submissions down into smaller groups, say groups
> of 10 or so patches.
> 
> Also consider what if one patch in the first ten has a problem, and
> this causes conflicts with the next 90 patches?

I understand there are a lot of patches, we are doing major re-factor
works and those patches are inter-related. I could try to see if I can
break those into smaller groups (maybe 20 - 30 patches a group).

John/David, are you prefer to see the submission like this?

Thanks
Wey 

