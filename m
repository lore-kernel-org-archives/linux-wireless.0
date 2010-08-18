Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0HRQkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:40:11 -0400
Subject: Re: [PATCH 1/2] iwlagn: do not check for AP mode for WEP keys
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1282149322-17928-2-git-send-email-wey-yi.w.guy@intel.com>
References: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1282149322-17928-2-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 18:40:04 +0200
Message-ID: <1282149604.5249.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-18 at 09:35 -0700, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Even when we configure WEP keys in AP mode
> ones without a station pointer are default
> keys, so don't check for AP mode here.

I don't think this needs to go into 2.6.35 (or 2.6.36, which I think you
meant?) since we don't support AP mode.

johannes


