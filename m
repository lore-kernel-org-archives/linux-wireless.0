Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43017 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaHTDPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 23:15:13 -0400
Date: Tue, 19 Aug 2014 23:04:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH v2 00/13] wil6210 misc updates
Message-ID: <20140820030458.GA4813@tuxdriver.com> (sfid-20140820_051517_501966_977A2D29)
References: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
 <3159817.tZ1i7iY0M1@lx-wigig-72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3159817.tZ1i7iY0M1@lx-wigig-72>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 18, 2014 at 10:46:39AM +0300, Vladimir Kondratiev wrote:
> On Wednesday, August 06, 2014 10:31:48 AM Dedy Lansky wrote:
> > Some updates and bug fixes for wil6210 driver.
> > 
> > Dedy Lansky (1):
> >   wil6210: Limit max number of associated stations
> > 
> > Vladimir Kondratiev (12):
> >   wil6210: map MAC timer for packet lifetime into debugfs
> >   wil6210: fix race in reset
> >   wil6210: update copyright year 2014
> >   wil6210: check error in wil_target_reset()
> >   wil6210: wait longer for hardware reset completion
> >   wil6210: Workaround for Sparrow with bad device id
> >   wil6210: convert debugfs to the table mode
> >   wil6210: fix beamforming data reporting
> >   wil6210: fix false "scan timeout"
> >   wil6210: fix free'd memory access in wil_if_free()
> >   wil6210: cfg80211_rx_mgmt to use GFP_ATOMIC
> >   wil6210: fix access after free in wil_pcie_remove()
> > 
> >  drivers/net/wireless/ath/wil6210/cfg80211.c   |   6 +-
> >  drivers/net/wireless/ath/wil6210/debugfs.c    | 331 ++++++++++++++++++++------
> >  drivers/net/wireless/ath/wil6210/interrupt.c  |   2 +-
> >  drivers/net/wireless/ath/wil6210/main.c       |  30 ++-
> >  drivers/net/wireless/ath/wil6210/netdev.c     |   8 +-
> >  drivers/net/wireless/ath/wil6210/pcie_bus.c   |   7 +-
> >  drivers/net/wireless/ath/wil6210/rx_reorder.c |  16 ++
> >  drivers/net/wireless/ath/wil6210/txrx.c       |   3 +-
> >  drivers/net/wireless/ath/wil6210/txrx.h       |   2 +-
> >  drivers/net/wireless/ath/wil6210/wil6210.h    |  17 +-
> >  drivers/net/wireless/ath/wil6210/wmi.c        |  47 ++--
> >  drivers/net/wireless/ath/wil6210/wmi.h        |   4 +-
> >  12 files changed, 327 insertions(+), 146 deletions(-)
> > 
> > 
> Hi John,
> 
> Could you please merge these patches? Somehow, it was forgotten.
> 
> Thanks, Vladimir

This pull request missed the merge window.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
