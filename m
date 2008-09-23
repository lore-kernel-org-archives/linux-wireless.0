Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42589 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYIWSWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 14:22:08 -0400
Date: Tue, 23 Sep 2008 14:21:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Helmut Schaa <hschaa@suse.de>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Message-ID: <20080923182114.GC26219@tuxdriver.com> (sfid-20080923_202214_071619_24B2035D)
References: <200809151416.07552.hschaa@suse.de> <200809151634.06448.hschaa@suse.de> <1221492529.10177.76.camel@localhost.localdomain> <200809151845.35841.hschaa@suse.de> <43e72e890809151821h5d40e750q10c78f4d20d27c79@mail.gmail.com> <87r67kzf7c.fsf@nokia.com> <1221552727.8916.19.camel@johannes.berg> <873ak0zcz9.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <873ak0zcz9.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2008 at 11:55:38AM +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Tue, 2008-09-16 at 11:07 +0300, Kalle Valo wrote:
> >
> >> I definitely want to see this background scan support in Wireless
> >> Extensions as well, otherwise it might prevent the real use of the
> >> feature.
> >
> > However, the more feature we keep stuffing into WEXT the less incentive
> > is there to actually do something about cfg80211. I'm with Luis here,
> > the fact that there are no tools anywhere is because those tools aren't
> > really very useful yet, not because it's not possible to get the tools
> > in.
> 
> I understand yours and Luis' points. But I still think that we should
> push cfg80211 acceptance first with the argument of more reliable
> method of configure 80211 devices, and only later start adding
> cfg80211-only features.

cfg80211-only features may be a great reason for people to move to
the new tools.  Considering how fragile WEXT has proven to be, I am
not at all in favor of continuing to extend it.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
