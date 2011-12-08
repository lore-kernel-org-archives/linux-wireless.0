Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1LHIdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 03:33:41 -0500
Subject: Re: [PATCH] Support mcast-rate in Mesh Node
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
In-Reply-To: <1323291855-8418-1-git-send-email-thomas@cozybit.com> (sfid-20111207_220454_229908_1A24981F)
References: <1323291855-8418-1-git-send-email-thomas@cozybit.com>
	 (sfid-20111207_220454_229908_1A24981F)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 09:33:38 +0100
Message-ID: <1323333218.3332.3.camel@jlt3.sipsolutions.net> (sfid-20111208_093345_318142_22FB8401)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 13:04 -0800, Thomas Pedersen wrote:

> +			if (rate)
> +				NLA_PUT_U32(msg, NL80211_ATTR_MCAST_RATE,
> +						(int)(rate * 10));
> +
> +				argv++;
> +				argc--;

Ahem.

johannes

