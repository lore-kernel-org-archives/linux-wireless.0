Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45442 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbaJUTeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 15:34:11 -0400
Message-ID: <1413920047.1998.18.camel@jlt4.sipsolutions.net> (sfid-20141021_213414_452130_A3C81C6E)
Subject: Re: [PATCH v2 2/6] mac80211:  allow creating wiphy devices with
 suggested name.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Oct 2014 21:34:07 +0200
In-Reply-To: <1413845378-27837-2-git-send-email-greearb@candelatech.com>
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
	 <1413845378-27837-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There seem to be two spaces in the subject - please fix that since we
need another spin anyway.

> + * @requested_name:  Requested name for this device.

please also just have one space here
also same comments as with cfg80211 - document NULL and the function
name change

> +struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
> +					   const struct ieee80211_ops *ops,
> +					   const char *requested_name);
> +
> +/**
> + * ieee80211_alloc_hw -  Allocate a new hardware device

another place where you have two spaces :)

johannes

