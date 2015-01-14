Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58103 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbbANIpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 03:45:30 -0500
Message-ID: <1421225127.1950.20.camel@sipsolutions.net> (sfid-20150114_094537_088078_8B20F23F)
Subject: Re: [PATCH] nl80211: send netdetect configuration info in
 NL80211_CMD_GET_WOWLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 14 Jan 2015 09:45:27 +0100
In-Reply-To: <1420805197-5831-1-git-send-email-luca@coelho.fi>
References: <1420805197-5831-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-09 at 14:06 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Send the netdetect configuration information in the response to
> NL8021_CMD_GET_WOWLAN commands.  This includes the scan interval,
> SSIDs to match and frequencies to scan.
> 
> Additionally, add the NL80211_WOWLAN_TRIG_NET_DETECT with
> NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED.

Applied.

johannes

