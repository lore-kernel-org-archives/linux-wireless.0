Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57260 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575AbZAGRZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 12:25:36 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] mac80211: extend/document powersave API
References: <1231264395.3654.10.camel@johannes>
	<1231273502.3767.4.camel@johannes> <878wpn5d64.fsf@nokia.com>
	<1231346625.3545.56.camel@johannes>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 07 Jan 2009 19:25:09 +0200
In-Reply-To: <1231346625.3545.56.camel@johannes> (ext Johannes Berg's message of "Wed\, 07 Jan 2009 17\:43\:45 +0100")
Message-ID: <87tz8b3u6i.fsf@nokia.com> (sfid-20090107_182541_813763_47D1219F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> This modifies hardware flags for powersave to support three different
> flags:
>  * IEEE80211_HW_SUPPORTS_PS - indicates general PS support
>  * IEEE80211_HW_PS_NULLFUNC_STACK - indicates nullfunc sending in software
>  * IEEE80211_HW_SUPPORTS_DYNAMIC_PS - indicates dynamic PS on the device
>
> It also adds documentation for all this which explains how to set the
> various flags.
>
> Additionally, it fixes a few things:
>  * a spot where && was used to test flags
>  * enable CONF_PS only when associated again
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Looks good to me.

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

> -set:
> + set:

Really? My emacs always indents it without space, should I fix my
settings?

-- 
Kalle Valo
