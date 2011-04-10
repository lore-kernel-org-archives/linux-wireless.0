Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1DJIP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 04:15:56 -0400
Subject: Re: [PATCH 04/16] iwlwifi: fix bugs in change_interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1302276636-12802-5-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1302276636-12802-5-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Apr 2011 10:15:52 +0200
Message-ID: <1302423352.3519.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-08 at 08:30 -0700, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If change_interface gets invoked during a firmware
> restart, it may crash; prevent that from happening
> by checking if ctx->vif is assigned.
> 
> Additionally, in my initial commit I forgot to set
> the vif->p2p variable correctly, so fix that too.
> 
> Cc: stable@kernel.org [2.6.38+]

This should go into .39 as well.

johannes


