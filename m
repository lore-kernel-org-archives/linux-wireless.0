Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaCCNEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:04:42 -0500
Message-ID: <1393851876.10039.3.camel@jlt4.sipsolutions.net> (sfid-20140303_140445_176128_E04EC0AE)
Subject: Re: [PATCH] mac80211: add missing update on rx status VHT flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 03 Mar 2014 14:04:36 +0100
In-Reply-To: <1393478054-19367-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140227_061505_092965_99A58775)
References: <1393478054-19367-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20140227_061505_092965_99A58775)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 13:14 +0800, Chun-Yeow Yeoh wrote:
> Add missing update on the rx status vht flag of the last
> data packet. Otherwise, cfg80211_calculate_bitrate_vht
> may not consider the channel width resulting in wrong
> calculation of the received bitrate.

Applied, thanks.

johannes

