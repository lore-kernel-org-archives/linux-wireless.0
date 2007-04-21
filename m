Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4750 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXDUTPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 15:15:33 -0400
Date: Sat, 21 Apr 2007 14:56:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dick <dm@chello.nl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211-7.0.4 ieee80211_ptr trouble
Message-ID: <20070421185622.GA7019@tuxdriver.com>
References: <1177144052.9892.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1177144052.9892.8.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 21, 2007 at 10:27:32AM +0200, Dick wrote:
> Hi all,
> 
> I'm trying to compile compatible mac80211 modules with
> linux-2.6.20-gentoo-r6 but I'm missing the ieee80211_ptr in struct
> net_device.
> 
> /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c: In functie 'ieee80211_ioctl_get_hw_features':
> /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c:119: fout: 'struct net_device' has no member named 'ieee80211_ptr'
> /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c: In functie 'ieee80211_ioctl_scan':
> /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c:172: fout: 'struct net_device' has no member named 'ieee80211_ptr'
> 
> What am I doing wrong, what happened to ieee80211_ptr?

You'll have to ask the gentoo guys...

John
-- 
John W. Linville
linville@tuxdriver.com
