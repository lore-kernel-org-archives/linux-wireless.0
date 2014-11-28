Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41409 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaK1N5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 08:57:45 -0500
Message-ID: <1417183062.27562.12.camel@sipsolutions.net> (sfid-20141128_145839_244587_29586280)
Subject: Re: [PATCH v5 4/4] cfg80211: return private regdom for self-managed
 devices
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 28 Nov 2014 14:57:42 +0100
In-Reply-To: <1417074298-12254-4-git-send-email-arik@wizery.com> (sfid-20141127_084502_939430_D1C52ACB)
References: <1417074298-12254-1-git-send-email-arik@wizery.com>
	 <1417074298-12254-4-git-send-email-arik@wizery.com>
	 (sfid-20141127_084502_939430_D1C52ACB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-27 at 09:44 +0200, Arik Nemtsov wrote:
>  	if (info->attrs[NL80211_ATTR_WIPHY]) {
> +		bool self_managed;
>  		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);

please add a blank line after variable declarations

johannes

