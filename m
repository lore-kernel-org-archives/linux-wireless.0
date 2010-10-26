Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47407 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab0JZNAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 09:00:13 -0400
Date: Tue, 26 Oct 2010 08:58:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: Bruno Randolf <br1@einfach.org>,
	ath5k-devel <ath5k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Access Channel Utilization
Message-ID: <20101026125825.GA2446@tuxdriver.com>
References: <AANLkTinqLcr7OpQZijX70aVE_P8gpUp=6RkozzVZH5Fm@mail.gmail.com>
 <201010261539.34710.br1@einfach.org>
 <AANLkTimKpBCr1sJvZyvCzScacup8DmVxNKzWBmLFRCya@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimKpBCr1sJvZyvCzScacup8DmVxNKzWBmLFRCya@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 26, 2010 at 04:44:35PM +1000, Jonathan Guerin wrote:
> On Tue, Oct 26, 2010 at 4:39 PM, Bruno Randolf <br1@einfach.org> wrote:
> > On Tue October 26 2010 15:24:42 Jonathan Guerin wrote:
> >> Hi,
> >>
> >> I'm trying to access the phy-layer stats that were recently added to
> >> cfg80211 and nl80211. I'm using a modified version of iw as per this
> >> patch:
> >> https://dev.openwrt.org/browser/trunk/package/iw/patches/110-survey_phy_sta
> >> ts.patch
> >>
> >> Unfortunately, the utilization stats don't appear to be getting sent
> >> back. I'm using ath5k as the underlying driver.
> >
> > are you missing this patch?
> >
> > "ath5k: Add channel time to survey data"
> > https://patchwork.kernel.org/patch/264831/
> 
> commit ebe5fd859224e706e0c027e1d6c3859684ae41fe
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Thu Oct 21 13:43:56 2010 -0400
> 
>     Revert "ath5k: Add channel time to survey data"
> 
>     This reverts commit 2f5155b69eca2a62a5defb15762019486a638a88.
> 
> Ah - the patch was reverted. Any reason why this was done?

http://marc.info/?l=linux-wireless&m=128768402812361&w=2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
