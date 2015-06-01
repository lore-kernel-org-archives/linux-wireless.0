Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33246 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbFAUgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 16:36:52 -0400
Message-ID: <1433191009.3505.18.camel@sipsolutions.net> (sfid-20150601_223655_455026_1660D5C0)
Subject: Re: [PATCH] minstrel_ht: Use RTS_CTS when STA is in DYNAMIC SMPS
 mode for frames sent using Nss>1.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 01 Jun 2015 22:36:49 +0200
In-Reply-To: <CABPxzYLW955-jJHKHYT+P0U8RM=GWajpCYDa8L-XtjCN71U0kw@mail.gmail.com> (sfid-20150601_201947_721441_892EB760)
References: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1390426022.4334.50.camel@jlt4.sipsolutions.net>
	 <CABPxzYK3pBK4QQh2W_vZbggkfszx+9d-zH+QC_uOXzDxfUMbUQ@mail.gmail.com>
	 <CABPxzYLW955-jJHKHYT+P0U8RM=GWajpCYDa8L-XtjCN71U0kw@mail.gmail.com>
	 (sfid-20150601_201947_721441_892EB760)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-01 at 23:49 +0530, Krishna Chaitanya wrote:
> On Thu, Jan 30, 2014 at 11:48 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
> > On Thu, Jan 23, 2014 at 2:57 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >>
> >> On Wed, 2014-01-22 at 12:27 +0530, Chaitanya T K wrote:
> >>
> >> > +             if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
> >> > +                     minstrel_mcs_groups[i].streams > 1) {
> >> > +                     mi->tx_flags |= IEEE80211_TX_RC_USE_RTS_CTS;
> >> > +             } else if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
> >> > +                     minstrel_mcs_groups[i].streams > 1) {
> >>
> >> Your indentation is off inside the if statements. I'll have to wait for
> >> nbd to review the patch itself, I guess.
> >>
> > Felix,
> >
> >  Any comments other than the indentation? If no, will send in the
> > v2 with indentation fixed.
> 
> Was checking my old submissions. This was marked as "Not Applicable" in
> patchwork.
> 
> Felix/Johannes,
> 
> Can you please explain to me the meaning of the status "Not Applicable"?

This patch is *ancient*, before we actually used patchwork properly ...

johannes

