Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:60574 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895Ab2IZTpE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 15:45:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Sam Leffler <sleffler@chromium.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 26 Sep 2012 12:44:39 -0700
Subject: RE: [PATCH 0/3] add scan flags support
Message-ID: <477F20668A386D41ADCC57781B1F7043083B590625@SC-VEXCH1.marvell.com> (sfid-20120926_214509_505843_5A879132)
References: <20120926165952.766801E10D3@sleffler.sfo.corp.google.com>
In-Reply-To: <20120926165952.766801E10D3@sleffler.sfo.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Sam for this patch series.

> These add per-scan request controls for optional behaviours we've found
> useful (they've been in Chrome OS for a long time).  A patch for iw will
> follow separately and the mods for wpa_supplicant are in our repo and
> I'll push them to Jouni if these are accepted.
> 
> Sam Leffler (3):
>   {nl,cfg}80211: add a flags word to scan requests
>   mac80211: add support for tx to abort scan requests
>   cfg80211: add support for flushing old scan results

These patches do not apply cleanly against mac80211-next.git.
Amit will take over Sam's patches and respin a v2 series.

Thanks,
Bing
