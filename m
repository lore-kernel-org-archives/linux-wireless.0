Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49261 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZKJKVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 05:21:14 -0500
Date: Tue, 10 Nov 2009 11:21:19 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC,PATCH 00/28] mwl8k updates, initial AP firmware support
Message-ID: <20091110102119.GR18639@mail.wantstofly.org>
References: <20091022181916.GB1583@mail.wantstofly.org> <20091104190723.GA10786@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091104190723.GA10786@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 02:07:23PM -0500, John W. Linville wrote:

> > This patch set includes an initial cut at adding support to mwl8k
> > for AP chips and firmware images.  AP firmware images present a
> > slightly different command set than STA firmware images do, and this
> > patch set adds support for those AP commands necessary to initialise
> > the firmware and allow packet reception.
> > 
> > Note that AP/STA interface creation on AP firmware images is not
> > supported yet, this will be added in another set of patches.
> > 
> > (All the code to allow using mwl8k in AP mode exists and works, with
> > 11n/AMPDU/hw crypto support, etc., it just needs to be cleaned up a
> > bit more and chopped up into logical chunks suitable for submission.)
> > 
> > Comments appreciated!
> 
> Are you OK with these being merged?  Or are their particular things
> you want comments on (or persons you want to comment)?

I just noticed that they have already been merged, but just for the
record, I'm happy with this patch set.

Thanks.
