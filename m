Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49844 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab0I1Pon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 11:44:43 -0400
Date: Tue, 28 Sep 2010 11:36:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Steve deRosier <steve@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
Subject: Re: [PATCH 5/9] libertas_tf: Moved firmware loading to probe in
 order to fetch MAC address
Message-ID: <20100928153609.GJ2440@tuxdriver.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
 <1283988329-44549-6-git-send-email-steve@cozybit.com>
 <e23a1b600a18f179fa72d2cadf724d17@localhost>
 <AANLkTi=r_RdEG-2=gzV7uFNJt1Nynp3qNC-38SQkzhO2@mail.gmail.com>
 <c9d7238e26d9e276d9c9ef9792f7c7f8@localhost>
 <AANLkTi=-JhwMmQK5ivX-FpSOV5_Pc3RfoswkFLFdGoFo@mail.gmail.com>
 <20100928152457.GH2440@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100928152457.GH2440@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 11:24:57AM -0400, John W. Linville wrote:

> > I think my mac80211 patch "mac80211: Fix dangling pointer in
> > ieee80211_xmit" stands 100% alone and fixes a clear bug.  I don't see
> > any need to delay that one.
> 
> I missed this before -- I'll take that patch on its own.

Actually, looks like I already did... :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
