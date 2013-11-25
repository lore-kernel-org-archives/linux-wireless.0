Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872Ab3KYQQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:16:34 -0500
Message-ID: <1385396191.4443.44.camel@jlt4.sipsolutions.net> (sfid-20131125_171641_780160_1777DDF4)
Subject: Re: Roaming with libertas and wpa_supplicant not working
From: Johannes Berg <johannes@sipsolutions.net>
To: Troels Nilsson <nilsson.troels@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 17:16:31 +0100
In-Reply-To: <loom.20131118T143002-687@post.gmane.org> (sfid-20131118_145509_206573_37D8C413)
References: <loom.20131118T143002-687@post.gmane.org>
	 (sfid-20131118_145509_206573_37D8C413)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-18 at 13:50 +0000, Troels Nilsson wrote:
> Hi,
> 
> We are having a problem with a custom device which uses the libertas wifi
> driver (on kernel 3.4.24) together with wpa_supplicant (0.7.3). More
> specifically, whenever wpa_supplicant attempts to roam to a different access
> point it gets a EALREADY error.
> 
> I have tracked down the problem to this check in sme.c:
> 
>         if (wdev->sme_state != CFG80211_SME_IDLE)
>                 return -EALREADY;

This no longer exists - please try a newer kernel.

johannes

