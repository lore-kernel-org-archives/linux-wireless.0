Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58046 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbbANIe5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 03:34:57 -0500
Message-ID: <1421224494.1950.13.camel@sipsolutions.net> (sfid-20150114_093502_272613_3834FC7A)
Subject: Re: [PATCH v3] mac80211: add TDLS supported channels correctly
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 14 Jan 2015 09:34:54 +0100
In-Reply-To: <1420641907-4350-1-git-send-email-arik@wizery.com> (sfid-20150107_154511_121153_383DC39D)
References: <1420641907-4350-1-git-send-email-arik@wizery.com>
	 (sfid-20150107_154511_121153_383DC39D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-07 at 16:45 +0200, Arik Nemtsov wrote:
> The function adding the supported channels IE during a TDLS connection had
> several issues:
> 1. If the entire subband is usable, the function exitted the loop without
>    adding it
> 2. The function only checked chandef_usable, ignoring flags like RADAR
>    which would prevent TDLS off-channel communcation.
> 3. HT20 was explicitly required in the chandef, while not a requirement
>    for TDLS off-channel.

Applied.

johannes

