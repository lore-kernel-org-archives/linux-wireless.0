Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:56157 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2LUScR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 13:32:17 -0500
Received: by mail-da0-f45.google.com with SMTP id w4so2201966dam.4
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 10:32:17 -0800 (PST)
Date: Fri, 21 Dec 2012 10:31:53 -0800
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com, j@wl.fi
Subject: Re: [PATCH v2 3/3] mac80211_hwsim: emulate proper beaconing
Message-ID: <20121221183153.GC24585@cable.cozybit.com> (sfid-20121221_193220_337150_500384BC)
References: <1356029871-17794-1-git-send-email-thomas@cozybit.com>
 <1356029871-17794-3-git-send-email-thomas@cozybit.com>
 <1356100638.9580.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356100638.9580.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 21, 2012 at 03:37:18PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-20 at 10:57 -0800, Thomas Pedersen wrote:
> 
> > +	u64 now = __mac80211_hwsim_get_tsf(data);
> 
> That looks like an endian bug.

Yep :)

Thomas
