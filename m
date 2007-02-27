Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4433 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbXB0NfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 08:35:22 -0500
Date: Tue, 27 Feb 2007 08:16:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: rename d80211 -> mac80211
Message-ID: <20070227131639.GA5826@tuxdriver.com>
References: <20070227032756.GA6569@tuxdriver.com> <1172573795.3870.244.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1172573795.3870.244.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2007 at 11:56:35AM +0100, Johannes Berg wrote:
> On Mon, 2007-02-26 at 22:27 -0500, John W. Linville wrote:
> 
> > I've changed all references in wireless-dev from d80211 to mac80211
> > and from D80211 to MAC80211,
> 
> And I notice that by "all references", you really mean it:
> 
> -T:     git kernel.org:/pub/scm/linux/kernel/git/mwu/d80211-drivers.git
> +T:     git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git

Well, that may have been a bit unintentional.  Still, it might be
appropriate...

Michael, any chance you'd like to rename your tree so as to preserve
my infallibility? :-)

John
-- 
John W. Linville
linville@tuxdriver.com
