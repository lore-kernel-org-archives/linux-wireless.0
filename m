Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59221 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbcBWKSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:18:49 -0500
Message-ID: <1456222727.2041.13.camel@sipsolutions.net> (sfid-20160223_111853_891162_B64B71CE)
Subject: Re: [PATCH v2 1/2] cfg80211: add radiotap VHT info to
 rtap_namespace_sizes
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2016 11:18:47 +0100
In-Reply-To: <1455878585-5525-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160219_114309_656111_55FCC207)
References: <1455878585-5525-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1455878585-5525-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20160219_114309_656111_55FCC207)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-19 at 11:43 +0100, Lorenzo Bianconi wrote:
> Add IEEE80211_RADIOTAP_VHT entry to rtap_namespace_sizes array in
> order to
> define alignment and size of VHT info in tx radiotap
> 
Applied this though.

johannes
