Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0L1Jdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:33:54 -0500
Subject: Re: Patches submitted should apply to which git repository?
From: Johannes Berg <johannes@sipsolutions.net>
To: Naveenan <initramd@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinxwNuZ1QxBKVMLycS=kmCmB1A9fpKrQYDH+TZV@mail.gmail.com>
References: <AANLkTi=MhYzv54WvEwYGh15KC4LHyM=EVd-s+1BG8pBT@mail.gmail.com>
	 <1293526293.3526.1.camel@jlt3.sipsolutions.net>
	 <AANLkTik9=r8tCouEg0joexH0_S9+WPfyDGDzq5fbMKOe@mail.gmail.com>
	 <1293527720.3526.3.camel@jlt3.sipsolutions.net>
	 <AANLkTinxwNuZ1QxBKVMLycS=kmCmB1A9fpKrQYDH+TZV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 10:33:52 +0100
Message-ID: <1293528832.3526.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 03:28 -0600, Naveenan wrote:
> [I apologize, I am resending this email with CC to the list]
> 
> >> I would say that the fix is not a critical one would would be useful
> >> if applied to wireless-2.6 too.
> >
> > Yes, if it's an important fix then you would have to send two versions.
> > Without seeing it, I can offer no advice on whether it is important
> > enough though.
> 
> Thanks a lot. I guess I will include the git repository I am diffing
> against after the "---" marker so that it would be applied to the
> right repository. Could you let me know if this style of sending
> patches is ok? I kind of would like to not send a patch and have it
> rejected due to a merge conflict :)

Yes, you can put anything after the first --- marker.

You can also indicate it in the subject: if it's intended for the
current kernel release still -- which is kinda late -- you can say
"[PATCH 2.6.37] mac80211: foobar"

johannes

