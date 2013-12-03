Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab3LCOUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 09:20:48 -0500
Message-ID: <1386080445.4393.27.camel@jlt4.sipsolutions.net> (sfid-20131203_152051_972595_08CB5EC0)
Subject: Re: [PATCH 1/4] nl80211: don't clear bitrate_mask twice
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 03 Dec 2013 15:20:45 +0100
In-Reply-To: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131203_095100_388101_6EA4CA8D)
References: <1386060648-6020-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131203_095100_388101_6EA4CA8D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 09:50 +0100, Janusz Dziedzic wrote:
> Don't clear cfg80211_bitrate_mask twice in
> nl80211_set_tx_bitrate_mask() function.

Applied.

johannes

