Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35534 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3AZUTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 15:19:37 -0500
Message-ID: <1359231601.8699.2.camel@jlt4.sipsolutions.net> (sfid-20130126_211941_601642_1CA5D551)
Subject: Re: [PATCH v2] compat: backport nla_put_be{16,32,64}()
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org
Date: Sat, 26 Jan 2013 21:20:01 +0100
In-Reply-To: <510320C8.6010407@hauke-m.de>
References: <1359024296-17724-1-git-send-email-johannes@sipsolutions.net>
	 <510320C8.6010407@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-26 at 01:18 +0100, Hauke Mehrtens wrote:
> On 01/24/2013 11:44 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > I intend to use these in nl80211.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  include/linux/compat-3.5.h | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> 
> Thank you for your patch.
> I added a missing #include <net/netlink.h> to it.

Oops, thanks :)

johannes

