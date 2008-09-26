Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:55772 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626AbYIZM5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 08:57:52 -0400
Message-ID: <48DCDC4E.9050501@lwfinger.net> (sfid-20080926_145813_087002_F035EE8D)
Date: Fri, 26 Sep 2008 07:57:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fixups for "make master iface not wireless"
References: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com>	 (sfid-20080926_110153_430052_F995BFEF) <1222428894.10563.115.camel@johannes.berg>
In-Reply-To: <1222428894.10563.115.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> In "mac80211: make master iface not wireless" I accidentally
> forgot to include these changes ... leading to the expected
> BUG_ON errors.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> The wme.c change is pretty much identical to Luis's fix,
> the iface.c change is not strictly required, it's just an
> additional cleanup.
> 
> Sorry I goofed this, it seems I simply forgot to 'quilt edit' the two
> files in question, this is the diff I had in my tree after quilt pop -a.

This one fixes it for me. As  both Luis's and Johannes's fixes were
available this morning, I only tested this one.

Larry

