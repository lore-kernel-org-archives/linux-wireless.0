Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37975 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbbBXJyR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 04:54:17 -0500
Message-ID: <1424771654.2192.8.camel@sipsolutions.net> (sfid-20150224_105422_434336_49C94B0B)
Subject: Re: [PATCH] nl80211: use loop index as type for net detect
 frequency results
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, pstew@chromium.org,
	samueltan@chromium.org
Date: Tue, 24 Feb 2015 10:54:14 +0100
In-Reply-To: <1423510155-7449-1-git-send-email-luca@coelho.fi>
References: <1423510155-7449-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-09 at 21:29 +0200, Luca Coelho wrote:
> From: Samuel Tan <samueltan@chromium.org>
> 
> We currently add nested members of the NL80211_ATTR_SCAN_FREQUENCIES
> as NLA_U32 attributes of type NL80211_ATTR_WIPHY_FREQ in
> cfg80211_net_detect_results. However, since there can be an arbitrary number of
> frequency results, we should use the loop index of the loop used to add the
> frequency results to NL80211_ATTR_SCAN_FREQUENCIES as the type (i.e. nla_type)
> for each result attribute, rather than a fixed type.
> 
> This change is in line with how nested members are added to
> NL80211_ATTR_SCAN_FREQUENCIES in the functions nl80211_send_wowlan_nd and
> nl80211_add_scan_req.

Applied, thanks.

johannes

