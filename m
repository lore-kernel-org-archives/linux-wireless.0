Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39625 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaHMLqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 07:46:37 -0400
Message-ID: <1407930393.21220.34.camel@jlt4.sipsolutions.net> (sfid-20140813_134640_389677_35697091)
Subject: Re: [PATCH 1/2] cfg80211: clarify BSS probe response vs. beacon data
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
Date: Wed, 13 Aug 2014 13:46:33 +0200
In-Reply-To: <CAB3XZEd0h_aPQSHr900+VWxdRw014QUP01-qj5rjsKsd+dhBsQ@mail.gmail.com> (sfid-20140813_133906_201204_D1C3F83B)
References: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEckyoDVShskF8rRe7DFuVMO-LBdhFDejiJ63SjhsEvmAA@mail.gmail.com>
	 <1407928122.21220.31.camel@jlt4.sipsolutions.net>
	 <CAB3XZEdOC1ERUm1HDK03qWQti35Z66EHL+0gD9=oBpcPfK2r4w@mail.gmail.com>
	 <1407928809.21220.33.camel@jlt4.sipsolutions.net>
	 <CAB3XZEd0h_aPQSHr900+VWxdRw014QUP01-qj5rjsKsd+dhBsQ@mail.gmail.com>
	 (sfid-20140813_133906_201204_D1C3F83B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-08-13 at 14:39 +0300, Eliad Peller wrote:

> > Maybe we should just get rid of the requirement to assign beacon_ies
> > with the bss_width() call and make free() smarter?
> 
> this will also require changing cfg80211_bss_update() to take care of
> this case, etc.
> not sure we really want to complicate it further more.

Good point. So let's say we change this to "known_from_beacon", is that
enough?

Debugging now - guess I'll poke again later.

johannes

