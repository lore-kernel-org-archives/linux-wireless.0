Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3FKLM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:12:58 -0400
Message-ID: <1370949174.8356.1.camel@jlt4.sipsolutions.net> (sfid-20130611_131304_792450_8FDB5FB9)
Subject: Re: [PATCH 0/2] mac80211 fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 11 Jun 2013 13:12:54 +0200
In-Reply-To: <1370940280-7876-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1370940280-7876-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-11 at 10:44 +0200, Simon Wunderlich wrote:
> Here are two small mac80211 fixes:
>  * I've been seeing a warning when doing DFS tests, which was triggered
>    by aborting the CAC when killing hostapd
>  * the rate control fix was sent as part of the v3 series of
>    "Add support for 5 and 10 MHz channels", but since it's an trivial
>    yet important fix I'm adding it to this series too.

Applied, thanks.

johannes

