Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBRTGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 14:06:06 -0500
Message-ID: <1392750354.5438.8.camel@jlt4.sipsolutions.net> (sfid-20140218_200610_248889_4734094A)
Subject: Re: [PATCH] ath9k: Enable U-APSD AP mode support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 18 Feb 2014 20:05:54 +0100
In-Reply-To: <20140218184108.GA24197@jouni.qca.qualcomm.com> (sfid-20140218_194116_149252_F9CC32B2)
References: <20140218184108.GA24197@jouni.qca.qualcomm.com>
	 (sfid-20140218_194116_149252_F9CC32B2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-18 at 20:41 +0200, Jouni Malinen wrote:
> mac80211 handles the actual operations, so ath9k can just indicate
> support for this. Based on initial tests, this combination seems to
> work fine.

I believe this is not true with aggregation sessions.

johannes

