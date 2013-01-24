Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3AXLFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 06:05:34 -0500
Message-ID: <1359025557.4639.4.camel@jlt4.sipsolutions.net> (sfid-20130124_120540_363464_1B210C96)
Subject: Re: [PATCH] compat: make hid_match_id static
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: backports@vger.kernel.org
Date: Thu, 24 Jan 2013 12:05:57 +0100
In-Reply-To: <1359024373-21365-1-git-send-email-johannes@sipsolutions.net> (sfid-20130124_114553_865444_8E08B51E)
References: <1359024373-21365-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130124_114553_865444_8E08B51E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-24 at 11:46 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Otherwise sparse complains.

Never mind, this then fails to compile in some cases, it seems?

johannes

