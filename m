Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4430 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYFXVR4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 17:17:56 -0400
Date: Tue, 24 Jun 2008 17:12:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Adrian Bunk <bunk@stusta.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: RFC: always enable MAC80211_RC_PID?
Message-ID: <20080624211222.GB25892@tuxdriver.com> (sfid-20080624_231800_644201_943A8C69)
References: <20080622125553.GB22539@cs181133002.pp.htv.fi> <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com> <1214298259.8967.260.camel@johannes.berg> <20080624124311.GC16021@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080624124311.GC16021@cs181140183.pp.htv.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 03:43:14PM +0300, Adrian Bunk wrote:

> Can we get one of either:
> - all selected mac80211 algorithms are built into the mac80211 module or

This seems fine to me.

> - all selected mac80211 algorithms (including the default one) are in
>   their own modules

We got here trying to avoid this one in the first place.

John
-- 
John W. Linville
linville@tuxdriver.com
