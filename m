Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab3CFMCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 07:02:35 -0500
Message-ID: <1362571344.8457.9.camel@jlt4.sipsolutions.net> (sfid-20130306_130239_106334_2874EE6E)
Subject: Re: mac80211: regression: fd0f979 no long authenticates w/ath9k_htc
From: Johannes Berg <johannes@sipsolutions.net>
To: Corey Richardson <corey@octayn.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Date: Wed, 06 Mar 2013 13:02:24 +0100
In-Reply-To: <CA++BO6QA9cFmM2kU4u8ASxWqJeGwUB1385awKfXLP=O0fA87NA@mail.gmail.com> (sfid-20130305_224931_592726_12A1CBB9)
References: <CA++BO6QA9cFmM2kU4u8ASxWqJeGwUB1385awKfXLP=O0fA87NA@mail.gmail.com>
	 (sfid-20130305_224931_592726_12A1CBB9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-05 at 16:49 -0500, Corey Richardson wrote:
> On Mon, Mar 4, 2013 at 3:42 AM, Corey Richardson <corey@octayn.net> wrote:
> > ath9k_htc driver , AR9271 (at least according to lsusb)
> >
> > commit fd0f979a1b67f0889aea24a7c7d2a54d6706a1cf
> > Author: Johannes Berg <johannes.berg@intel.com>
> > Date:   Thu Feb 7 00:14:51 2013 +0100
> >
> >     mac80211: simplify idle handling
> >
> >     Now that we have channel contexts, idle is (pretty
> >     much) equivalent to not having a channel context.
> >     Change the code to use this relation so that there
> >     no longer is a need for a lot of idle recalculate
> >     calls everywhere.
> >
> >     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> >
> > :040000 040000 85b3d4d114efb012773b4c7e1728b5bcae2e6b37
> > 3ff33170763520b03e84e067f91cc0a8334e4d36 M    net
> >
> > any more info needed?
> 
> I noticed the mail didn't get through to all lists, perhaps the
> attachments were too large? (~135K)

It did get through, at least here, but I didn't really see what part of
the change could have caused it; I'm not really familiar with ath9k_htc.

Do you think you could run trace-cmd to capture what's going on before
and after?

johannes

