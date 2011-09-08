Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab1IHHB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 03:01:57 -0400
Subject: Re: [PATCH v2 1/3] mac80211: Start implementing QoS support for
 mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1315442994-304-2-git-send-email-javier@cozybit.com> (sfid-20110908_025041_216336_C4FBD5EE)
References: <1315442994-304-1-git-send-email-javier@cozybit.com>
	 <1315442994-304-2-git-send-email-javier@cozybit.com>
	 (sfid-20110908_025041_216336_C4FBD5EE)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Sep 2011 09:01:52 +0200
Message-ID: <1315465312.3948.4.camel@jlt3.sipsolutions.net> (sfid-20110908_090201_130804_F5E52BF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-07 at 17:49 -0700, Javier Cardona wrote:

> +	/* For mesh, the use of the QoS header is mandatory */
> +	if (ieee80211_vif_is_mesh(&sdata->vif))
> +		sta_flags |= WLAN_STA_WME;
> +

With patch 3, this piece seems unnecessary?

johannes

