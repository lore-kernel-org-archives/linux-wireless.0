Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45256 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaFWJez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 05:34:55 -0400
Message-ID: <1403516075.4418.9.camel@jlt4.sipsolutions.net> (sfid-20140623_113543_285017_C5E38519)
Subject: Re: [RFC 2/3] cfg80211: expose cfg80211_disable_40mhz_24ghz module
 parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 23 Jun 2014 11:34:35 +0200
In-Reply-To: <1402996581-10764-3-git-send-email-arend@broadcom.com>
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>
	 <1402996581-10764-3-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-17 at 11:16 +0200, Arend van Spriel wrote:

>  /**
> + * wiphy_is_40mhz_24ghz_disabled - check whether 40MHz bandwidth in 2.4G

that seems incomplete :)

> + * @wiphy: The wiphy to check.
> + *
> + * Return: true is 40MHz is disabled in 2.4G band.
> + */
> +bool wiphy_is_40mhz_24ghz_disabled(struct wiphy *wiphy);

Why should that have a wiphy argument?

Might also be simpler to just export the variable?

johannes

