Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51663 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbZKDTPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 14:15:04 -0500
Date: Wed, 4 Nov 2009 14:07:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC,PATCH 00/28] mwl8k updates, initial AP firmware support
Message-ID: <20091104190723.GA10786@tuxdriver.com>
References: <20091022181916.GB1583@mail.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091022181916.GB1583@mail.wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 22, 2009 at 08:19:16PM +0200, Lennert Buytenhek wrote:
> This patch set includes an initial cut at adding support to mwl8k
> for AP chips and firmware images.  AP firmware images present a
> slightly different command set than STA firmware images do, and this
> patch set adds support for those AP commands necessary to initialise
> the firmware and allow packet reception.
> 
> Note that AP/STA interface creation on AP firmware images is not
> supported yet, this will be added in another set of patches.
> 
> (All the code to allow using mwl8k in AP mode exists and works, with
> 11n/AMPDU/hw crypto support, etc., it just needs to be cleaned up a
> bit more and chopped up into logical chunks suitable for submission.)
> 
> Comments appreciated!

Are you OK with these being merged?  Or are their particular things
you want comments on (or persons you want to comment)?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
