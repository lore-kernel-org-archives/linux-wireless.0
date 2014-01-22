Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56560 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbaAVJ7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:59:25 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so3983371eek.27
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 01:59:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390378907.4334.2.camel@jlt4.sipsolutions.net>
References: <1390334699.6199.67.camel@jlt4.sipsolutions.net>
	<CAHS2MGOVvv92L7c85Z0J70mt8kM9nG-P=2G-diL4UsC6MVTJgg@mail.gmail.com>
	<1390378907.4334.2.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 17:59:24 +0800
Message-ID: <CAEFj984Y=VRVxT7NRdmN3iLPWEQt7qJGm-fix9zrxExrpAFORg@mail.gmail.com> (sfid-20140122_105929_187284_467CBE67)
Subject: Re: [PATCH] mac80211: mesh: fix mesh_id check
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Indeed, this part seems to only be in 3.13 - probably got cleaned up in
> somebody else's patches. I think though mac80211 should probably check
> ifmsh->mesh_id_len and not sdata->wdev.mesh_id_len?
Agreed.

> Also, cfg80211 seems to be missing this check in nl80211_channel_switch(), no?
This checking is required for FullMAC implementation, right?

---
Chun-Yeow
