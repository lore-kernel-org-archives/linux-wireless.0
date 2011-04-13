Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40415 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1DMNAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 09:00:32 -0400
Date: Wed, 13 Apr 2011 08:51:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: sedat.dilek@gmail.com
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2 1/7] ath5k: optimize tx descriptor setup
Message-ID: <20110413125134.GA4832@tuxdriver.com>
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
 <1302646041-3917-1-git-send-email-nbd@openwrt.org>
 <BANLkTingC8r-obXeYxjbHVr2G80MCbhyMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTingC8r-obXeYxjbHVr2G80MCbhyMQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 13, 2011 at 06:23:40AM +0200, Sedat Dilek wrote:
> On Wed, Apr 13, 2011 at 12:07 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> > Use local variables to reduce the number of load/store operations on uncached
> > memory.
> >
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>

> Looks like this v2 did not found its way to wireless-next [1].

That's what happens, when it is posted after I've already merged the v1. :-)

I fixed things up and will commit the difference with the following message:

    ath5k: improve comments for optimized tx descriptor setup
    
    Comment the use of local variables to reduce the number of load/store
    operations on uncached memory, in hopes of not losing this optimization
    accidentally in the future.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
