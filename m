Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab3CESzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 13:55:10 -0500
Message-ID: <1362509703.8224.6.camel@jlt4.sipsolutions.net> (sfid-20130305_195516_778896_1BD54674)
Subject: Re: [PATCH 6/6] mac80211: init mesh timer for user authed STAs
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Tue, 05 Mar 2013 19:55:03 +0100
In-Reply-To: <CAG6hwVNshckALR04DtN2-0Vxzijn1b0DF_C-VUNY2RDQZUE=4A@mail.gmail.com> (sfid-20130304_221127_684985_FE556358)
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
	 <1362204172-28307-6-git-send-email-thomas@cozybit.com>
	 <1362409909.21028.17.camel@jlt4.sipsolutions.net>
	 <CAG6hwVMAdR4KCMq0x5NvvLUAegLpuYreEn8wuFkZStg+J9JvoA@mail.gmail.com>
	 <CAG6hwVNshckALR04DtN2-0Vxzijn1b0DF_C-VUNY2RDQZUE=4A@mail.gmail.com>
	 (sfid-20130304_221127_684985_FE556358)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 13:10 -0800, Thomas Pedersen wrote:

> >> Shouldn't this patch go to 3.9, instead of being based on userspace MPM?
> >
> > I doubt anyone is even exercising the above scenario, but sure, I can
> > resubmit for 3.9.
> 
> Uh instead of submitting one patch for 3.9 then another for
> mac80211-next, will you just take this one for mac80211-next? AFAIK no
> one is hitting this anyway.

Ok.

johannes

