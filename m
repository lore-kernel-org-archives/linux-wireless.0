Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1IWKUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 06:20:37 -0400
Subject: Re: [RFC 1/2] nl80211/cfg80211: Add support to disable CCK rate
 for management frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>
In-Reply-To: <1316703516-24216-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316703516-24216-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 12:20:32 +0200
Message-ID: <1316773232.4058.1.camel@jlt3.sipsolutions.net> (sfid-20110923_122040_791324_AA3B7D3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 20:28 +0530, Rajkumar Manoharan wrote:

Looks fine, minor nitpick:
 
> +	request->no_cck = nla_get_flag(info->attrs
> +					[NL80211_ATTR_TX_NO_CCK_RATE]);

I think that'd be nicer as
	request->no_cck =
		nla_get_flag(...);

even if potentially that goes above 80 cols.


> +	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);

Or I guess it probably won't if this fits :)

Thanks!

johannes

