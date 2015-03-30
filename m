Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45661 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbbC3Isq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:48:46 -0400
Message-ID: <1427705323.26117.13.camel@sipsolutions.net> (sfid-20150330_104849_881689_465E7879)
Subject: Re: [PATCHv3 1/2] mac80211: IBSS fix scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Mar 2015 10:48:43 +0200
In-Reply-To: <1426829821-5001-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150320_063832_806899_28F92BA1)
References: <1426829821-5001-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150320_063832_806899_28F92BA1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-03-20 at 06:37 +0100, Janusz Dziedzic wrote:
> In case of wide bandwidth (wider than 20MHz) used by IBSS,
> scan all channels in chandef to be able to find neighboring
> IBSS netwqworks that use the same overall channels but a different
> control channel.

Both applied.

johannes

