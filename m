Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1EDRZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 13:25:20 -0400
Subject: Re: [PATCH 13/13] ath9k: fix beaconing for mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <BANLkTikOOvGfzV4YK6_0LWnF3jFQy-N0ig@mail.gmail.com> (sfid-20110504_191439_734887_11EB4C95)
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
	 <1304467039-7730-14-git-send-email-javier@cozybit.com>
	 <4DC165D7.50403@openwrt.org>
	 <BANLkTikOOvGfzV4YK6_0LWnF3jFQy-N0ig@mail.gmail.com>
	 (sfid-20110504_191439_734887_11EB4C95)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 19:25:14 +0200
Message-ID: <1304529914.3563.25.camel@jlt3.sipsolutions.net> (sfid-20110504_192523_326213_C98F4D3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-04 at 10:13 -0700, Javier Cardona wrote:

> The current version of the draft defines a different beaconing mode
> specific for mesh.

Out of curiosity, what does that mode look like?

johannes

