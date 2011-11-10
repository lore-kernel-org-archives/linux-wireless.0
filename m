Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1KJIFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 03:05:36 -0500
Subject: Re: [PATCH 06/28] iwlagn: use per-vif AC parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1320885571-19122-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023421_218472_F7808A5B)
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1320885571-19122-7-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20111110_023421_218472_F7808A5B)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 09:05:31 +0100
Message-ID: <1320912331.3967.2.camel@jlt3.sipsolutions.net> (sfid-20111110_090538_475037_5AB850BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 16:39 -0800, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Eliad added the ability to configure AC parameters
> per virtual interface; make use of this in iwlwifi
> and set the parameters in the right context. Since
> storage and uploading to the device is already per
> context, this is sufficient.

This breaks P2P and patch 13 fixes it again, can't we get those in the
right order?

johannes


