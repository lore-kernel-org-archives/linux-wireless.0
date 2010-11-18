Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:39090 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0KRCkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 21:40:12 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 18:39:59 -0800
Date: Wed, 17 Nov 2010 18:40:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Mark Mentovai <mark@moxienet.com>, <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] cfg80211: fix can_beacon_sec_chan, reenable HT40
Message-ID: <20101118024008.GA2009@tux>
References: <AANLkTi=Z+60nkSv4umXyDdSp0_SUR84he5GYTZLO9=5E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTi=Z+60nkSv4umXyDdSp0_SUR84he5GYTZLO9=5E@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 01:34:37PM -0800, Mark Mentovai wrote:
> This follows wireless-testing 9236d838c920e90708570d9bbd7bb82d30a38130
> ("cfg80211: fix extension channel checks to initiate communication") and
> fixes accidental case fall-through. Without this fix, HT40 is entirely
> blocked.
> 
> Cc: stable@kernel.org
> Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: Mark Mentovai <mark@moxienet.com>

Thanks,

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com

On your next patch please address John.

  Luis
