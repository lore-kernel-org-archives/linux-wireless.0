Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaAJS2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 13:28:06 -0500
Message-ID: <1389378478.12683.0.camel@jlt4.sipsolutions.net> (sfid-20140110_192811_262757_801A82CB)
Subject: Re: [PATCH IW] util: parse NL80211_CMD_CHANNEL_SWITCH
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 10 Jan 2014 19:27:58 +0100
In-Reply-To: <1389371137-30282-1-git-send-email-luca@coelho.fi>
References: <1389371137-30282-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-10 at 18:25 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Add the NL80211_CMD_CHANNEL_SWITCH definition to the nl80211 commands
> array so that it prints out something useful in the phy info.

I'll refresh the list in util.c instead (though not immediately, need to
sort out what I can already commit and what I can't ...)

johannes

