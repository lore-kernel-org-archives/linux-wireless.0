Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59212 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbcBWKPb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:15:31 -0500
Message-ID: <1456222528.2041.12.camel@sipsolutions.net> (sfid-20160223_111535_116635_00FC5DCA)
Subject: Re: [PATCH] cfg80211: Add global RRM capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Beni Lev <beni.lev@intel.com>
Date: Tue, 23 Feb 2016 11:15:28 +0100
In-Reply-To: <1455733800-13230-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1455733800-13230-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-17 at 20:30 +0200, Emmanuel Grumbach wrote:
> From: Beni Lev <beni.lev@intel.com>
> 
> Today, the supplicant will add the RRM capabilities
> Information Element in the association request only if
> Quiet period is supported (NL80211_FEATURE_QUIET).
> 
Applied.

johannes
