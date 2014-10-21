Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45461 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498AbaJUTf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 15:35:26 -0400
Message-ID: <1413920123.1998.20.camel@jlt4.sipsolutions.net> (sfid-20141021_213533_261289_A8308DC3)
Subject: Re: [PATCH v2 3/6] mac80211-hwsim: support creating radios with
 specific name.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Oct 2014 21:35:23 +0200
In-Reply-To: <1413845378-27837-3-git-send-email-greearb@candelatech.com>
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
	 <1413845378-27837-3-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 15:49 -0700, greearb@candelatech.com wrote:

> @@ -2023,7 +2023,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
>  				       const struct ieee80211_regdomain *regd,
>  				       bool reg_strict, bool p2p_device,
>  				       bool use_chanctx, bool destroy_on_close,
> -				       u32 portid)
> +				       u32 portid, char *hwname)

could also be const?

> +	char *hwname = NULL;

const as well then, I guess.

johannes

