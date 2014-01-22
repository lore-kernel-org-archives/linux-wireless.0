Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaAVJDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:03:01 -0500
Message-ID: <1390381374.4334.13.camel@jlt4.sipsolutions.net> (sfid-20140122_100306_443465_92218E87)
Subject: Re: [PATCH] mac80211: fix the increment of mesh precedence value
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Wed, 22 Jan 2014 10:02:54 +0100
In-Reply-To: <1390373584-24716-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140122_075328_936337_B2DBF8A4)
References: <1390373584-24716-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20140122_075328_936337_B2DBF8A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 14:53 +0800, Chun-Yeow Yeoh wrote:
> The mesh precedence value in ieee80211_channel_switch
> should be incremented or set to 1 only if this is the
> initiator of mesh channel switch. For non-initiator,
> the precedence value has updated using the Mesh
> Channel Switch Parameters element. Fix this.

Applied.

johannes

