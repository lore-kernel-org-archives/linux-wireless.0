Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4656 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbYCGUDd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 15:03:33 -0500
Date: Fri, 7 Mar 2008 14:34:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Vladimir Koutny <vlado@work.ksp.sk>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: 2.6.24, mac80211 and b/g switching
Message-ID: <20080307193429.GA5561@tuxdriver.com> (sfid-20080307_200336_669157_CB067E05)
References: <47D160E4.3040503@work.ksp.sk> <1204909966.6387.31.camel@johannes.berg> <47D17EDF.4010100@work.ksp.sk> <200803071916.28776.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200803071916.28776.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 07, 2008 at 07:16:28PM +0100, Michael Buesch wrote:
> On Friday 07 March 2008 18:43:59 Vladimir Koutny wrote:

> > Do you think that taking mac80211 from wireless-2.6 (or -testing or
> > whatever) would cause way too many conflicts when merged back to 2.6.24?
> >   Or am I on my own to fix this somehow in 2.6.24?
> 
> OpenWRT ported a rather recent mac80211 back to 2.6.23. So it shouldn't be too hard.

Current 2.6.24-based Fedora kernels take current mac80211 bits fairly easily.

John
-- 
John W. Linville
linville@tuxdriver.com
