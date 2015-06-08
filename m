Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46135 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbbFHKGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 06:06:49 -0400
Message-ID: <1433758004.2106.7.camel@sipsolutions.net> (sfid-20150608_120654_615365_9D1767BD)
Subject: Re: kmalloc panic
From: Johannes Berg <johannes@sipsolutions.net>
To: Toan Pham <tpham3783@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
	pavani <pavani.muthyala@redpinesignals.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	Linux Kernel Network Developers <netdev@vger.kernel.org>
Date: Mon, 08 Jun 2015 12:06:44 +0200
In-Reply-To: <CAGNmLEP0o9bnGEh-P=AVxUp-_rh9pO-zOiwUq_HboptRQ60dTA@mail.gmail.com> (sfid-20150607_011021_446015_1BD068E9)
References: <5565CAA1.9070409@redpinesignals.com>
	 <CAM_iQpUGLW44vzkN-5TJ9ww3RSz=2sRMnm7GKP6V0N9WGszRZQ@mail.gmail.com>
	 <1432803793.2459.2.camel@sipsolutions.net>
	 <CAGNmLEP0o9bnGEh-P=AVxUp-_rh9pO-zOiwUq_HboptRQ60dTA@mail.gmail.com>
	 (sfid-20150607_011021_446015_1BD068E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-06-06 at 19:10 -0400, Toan Pham wrote:
> I am experiencing a similar issue on another system (at91sam9n12) that
> uses Redpine Signal Wireless Driver 1.1.0.  I do not know the root
> cause yet,  but it may be related to the Redpine Signals driver.  Will
> update this mailing list if the problem is with the redpine driver.
> thanks

Please don't top-post.

It's almost certainly related to the redpine driver, but apparently not
using the upstream "rsi" driver ... you're in the wrong place here.

I'll note that the driver should probably be converted to cfg80211
instead of having its own wext handling (which I'd think is causing this
issue)

johannes

