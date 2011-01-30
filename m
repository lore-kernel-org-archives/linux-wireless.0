Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1A3Kop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 05:44:45 -0500
Subject: Re: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTinc6LpTPg1q8qM3mHP=8mniWVCrdKC0OLTOTC1B@mail.gmail.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295816579-28925-3-git-send-email-arik@wizery.com>
	 <1295868924.3639.2.camel@jlt3.sipsolutions.net>
	 <AANLkTinJo7EV7zr=Z6oN3M2X3=gcv1W8G7cpbHPPNs=0@mail.gmail.com>
	 <1295950325.3650.5.camel@jlt3.sipsolutions.net>
	 <AANLkTin49svPAzuhH-ENdzoa4FnTRyOeizKrTLNYLOeu@mail.gmail.com>
	 <1296030720.3635.14.camel@jlt3.sipsolutions.net>
	 <AANLkTimTASMMUhofp=1o=Z6-dY7v8T8uoNLbqYK4TStv@mail.gmail.com>
	 <1296134959.3622.37.camel@jlt3.sipsolutions.net>
	 <AANLkTinc6LpTPg1q8qM3mHP=8mniWVCrdKC0OLTOTC1B@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Jan 2011 11:44:42 +0100
Message-ID: <1296384282.3616.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-30 at 12:34 +0200, Arik Nemtsov wrote:


> > Wait, no, I don't get it -- what does the nl80211 API have to do with
> > how mac80211 manages it? I think for the nl80211 API the new command
> > doesn't make a whole lot of sense. What happens in mac80211 I don't
> > think matters much.
> 
> I guess I misunderstood your original suggestion. Are you suggesting I
> put the probe resp as part of the NL80211_CMD_SET_BSS cmd?
> I'm ok with that.

Yes, that's what I was thinking.

johannes

