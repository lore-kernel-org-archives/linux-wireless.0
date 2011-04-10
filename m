Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1DJIPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 04:15:50 -0400
Subject: Re: [PATCH 16/16] iwlagn: downgrade warning on unknown TLV
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1302276636-12802-17-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1302276636-12802-17-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Apr 2011 10:15:46 +0200
Message-ID: <1302423346.3519.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-08 at 08:30 -0700, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If we maintain API properly, then there isn't
> really a reason to warn about this since we'll
> just be adding things that are safe to ignore,
> so downgrade the warning to debug info level.

This might be worthwhile for .39 since we'll be releasing firmware with
some TLVs it doesn't understand eventually.

johannes

