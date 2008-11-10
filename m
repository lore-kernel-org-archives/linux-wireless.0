Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20961 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbYKJB62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 20:58:28 -0500
Subject: Re: [PATCH 1/2] cfg80211: add support for custom firmware
	regulatory solutions
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1226109668-13778-2-git-send-email-lrodriguez@atheros.com>
References: <1226109668-13778-1-git-send-email-lrodriguez@atheros.com>
	 <1226109668-13778-2-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 09:58:44 +0800
Message-Id: <1226282324.2604.282.camel@debian.sh.intel.com> (sfid-20081110_025920_459384_B24E6B7F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-11-08 at 10:01 +0800, Luis R. Rodriguez wrote:
> This adds API to cfg80211 to allow wireless drivers to inform
> us if their firmware can handle regulatory considerations *and*
> they cannot map these regulatory domains to an ISO / IEC 3166
> alpha2. In these cases we skip the first regulatory hint instead
> of expecting the driver to build their own regulatory structure,
> providing us with an alpha2, or using the reg_notifier().
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Thanks!

Acked-by: Zhu Yi <yi.zhu@intel.com>

-yi

