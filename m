Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27092 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715AbZCSVoq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 17:44:46 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 14:44:45 -0700
Date: Thu, 19 Mar 2009 13:44:06 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] Use the regulatory bandwidth and export HT40
	stuff
Message-ID: <20090319204406.GA14753@tesla> (sfid-20090319_224449_168749_05993BD1)
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com> <1237491647.5100.114.camel@johannes.local> <43e72e890903191328j15a53a5au1f0162e53daa2a14@mail.gmail.com> <1237498852.5100.121.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1237498852.5100.121.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2009 at 02:40:52PM -0700, Johannes Berg wrote:
> On Thu, 2009-03-19 at 13:28 -0700, Luis R. Rodriguez wrote:
> > On Thu, Mar 19, 2009 at 12:40 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > John,
> > >
> > > please back out this series, I'm not sure I agree with the concept and
> > > I'm sure there are potential bugs that can make it segfault.
> > 
> > Can you be more elaborate?
> 
> reg_process_ht_flags_channel doesn't initialise channel_before and
> channel_after.

I can fix that, two lines.

  Luis
