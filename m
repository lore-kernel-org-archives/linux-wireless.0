Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2599 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbXGQSco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 14:32:44 -0400
Date: Tue, 17 Jul 2007 14:04:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: patches ping
Message-ID: <20070717180417.GE9037@tuxdriver.com>
References: <1184674109.3773.70.camel@johannes.berg> <469CE051.5060805@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <469CE051.5060805@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 17, 2007 at 10:29:21AM -0500, Larry Finger wrote:
> Johannes Berg wrote:
> >What happened to my patches
> >
> > * mac80211: regdomain.c needs to include ieee80211_i.h
> > * mac80211: kill PRISM2_HOSTAPD_UPDATE_IF sub-ioctl
> > * mac80211: move wpa trigger to debugfs
> > * mac80211: kill PRISM2_PARAM_AP_AUTH_ALGS
> 
> Add to Johannes's list
> 
> [PATCH V3] mac80211: Implementation of SIOCSIWRATE

commit 1fd5e589d8c7d3cd42ddd39358338766cfcedec8
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Tue Jul 10 19:32:10 2007 +0200

    [PATCH] mac80211: Implementation of SIOCSIWRATE

    The WEXT ioctl SIOCSIWRATE is not implemented in mac80211. This patch
    adds the missing routine. It supports the 'auto' keyword, fixed rates,
    and the combination of 'auto' and a fixed rate to select an upper bound.

    Based on the patch from Mohamed Abbas <mabbas@linux.intel.com>.

    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
    Signed-off-by: Jiri Benc <jbenc@suse.cz>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

That was from a recent pull of linux-2.6.  Maybe you should pull again?

John
-- 
John W. Linville
linville@tuxdriver.com
