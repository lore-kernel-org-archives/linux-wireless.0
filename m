Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:50187 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab3DXLb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 07:31:59 -0400
Message-ID: <1366803109.21854.12.camel@jlt4.sipsolutions.net> (sfid-20130424_133203_039672_919478D5)
Subject: Re: [PATCH] cfg80211: Cover  60g regulatory class in
 ieee80211_operating_class_to_band
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 24 Apr 2013 13:31:49 +0200
In-Reply-To: <9494232.kA7XtV1HX3@lx-vladimir>
References: <9494232.kA7XtV1HX3@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-23 at 09:54 +0300, Vladimir Kondratiev wrote:
> Hi,
> 
> In the function ieee80211_operating_class_to_band, introduced in commit
> 1ce3e82b0eb472161313183be0033e46d5c4bbaf cfg80211: add ieee80211_operating_class_to_band,
> 60GHz band is not covered. Patch below adds 60g.
> 
> Thanks, Vladimir

Applied. I'd really prefer if you could format your patches properly
though, with the extra text behind a --- line. Next time please.

johannes

