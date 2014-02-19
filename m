Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaBSLA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:00:29 -0500
Message-ID: <1392807623.4733.13.camel@jlt4.sipsolutions.net> (sfid-20140219_120034_608590_BCAE1F10)
Subject: Re: [PATCH 0/7] api clean: ieee80211_{dsss_chan_to_freq,
 freq_to_dsss_chan}
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 12:00:23 +0100
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143626_007835_64DA570F)
References: <cover.1392728354.git.gamerh2o@gmail.com>
	 (sfid-20140218_143626_007835_64DA570F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-18 at 21:35 +0800, Zhao, Gang wrote:
> This patch set's purpose is to remove function
> ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}, by replacing them
> with more generic function ieee80211_{channel_to_frequency,
> frequency_to_channel}.

I'm fine with this, but I won't take the patches. John, please take
patch 7 as well as the rest if/when you decide to do so.

johannes

