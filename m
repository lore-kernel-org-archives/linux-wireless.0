Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59457 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0I1P3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 11:29:35 -0400
Date: Tue, 28 Sep 2010 11:24:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Steve deRosier <steve@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
Subject: Re: [PATCH 5/9] libertas_tf: Moved firmware loading to probe in
 order to fetch MAC address
Message-ID: <20100928152457.GH2440@tuxdriver.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
 <1283988329-44549-6-git-send-email-steve@cozybit.com>
 <e23a1b600a18f179fa72d2cadf724d17@localhost>
 <AANLkTi=r_RdEG-2=gzV7uFNJt1Nynp3qNC-38SQkzhO2@mail.gmail.com>
 <c9d7238e26d9e276d9c9ef9792f7c7f8@localhost>
 <AANLkTi=-JhwMmQK5ivX-FpSOV5_Pc3RfoswkFLFdGoFo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=-JhwMmQK5ivX-FpSOV5_Pc3RfoswkFLFdGoFo@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 09, 2010 at 08:34:41PM -0700, Steve deRosier wrote:

> In light of the above, and Julian's comments, I'm going to rework the
> libertas_tf patch set a little.  I'll make the following two changes:
> 1. Restrict building to module-only for now.  This avoids building it
> into the kernel which we know will break.  Latter when I have time
> I'll happily do what's necessary to make the fix Johannes wants, but
> as it's not trivial I want to get a base down.
> 2. I'll change a few things around as Julian's advised so the patch
> set makes a bit more sense. I'll be also killing some inadvertent
> white-space changes that were mistakes.

I interpret this as "drop this series -- new series will replace it".

> I think my mac80211 patch "mac80211: Fix dangling pointer in
> ieee80211_xmit" stands 100% alone and fixes a clear bug.  I don't see
> any need to delay that one.

I missed this before -- I'll take that patch on its own.

> It might be a few days before I get these in.

Is this still coming?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
