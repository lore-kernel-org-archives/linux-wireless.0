Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbaAVKJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:09:28 -0500
Message-ID: <1390385361.4334.25.camel@jlt4.sipsolutions.net> (sfid-20140122_110936_448188_04807A7C)
Subject: Re: [PATCH] mac80211: mesh: fix mesh_id check
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Date: Wed, 22 Jan 2014 11:09:21 +0100
In-Reply-To: <CAEFj984Y=VRVxT7NRdmN3iLPWEQt7qJGm-fix9zrxExrpAFORg@mail.gmail.com> (sfid-20140122_105925_273477_750EAC5C)
References: <1390334699.6199.67.camel@jlt4.sipsolutions.net>
	 <CAHS2MGOVvv92L7c85Z0J70mt8kM9nG-P=2G-diL4UsC6MVTJgg@mail.gmail.com>
	 <1390378907.4334.2.camel@jlt4.sipsolutions.net>
	 <CAEFj984Y=VRVxT7NRdmN3iLPWEQt7qJGm-fix9zrxExrpAFORg@mail.gmail.com>
	 (sfid-20140122_105925_273477_750EAC5C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 17:59 +0800, Yeoh Chun-Yeow wrote:

> > Also, cfg80211 seems to be missing this check in nl80211_channel_switch(), no?
> This checking is required for FullMAC implementation, right?

Which is unlikely to support it, but generally it seems better to do it
closer to userspace. I've posted a patch for it.

johannes

