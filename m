Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49444 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbaFXRIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 13:08:15 -0400
Message-ID: <1403629678.10831.14.camel@jlt4.sipsolutions.net> (sfid-20140624_190818_634601_B2BAE21D)
Subject: Re: pull-request: mac80211-next 2014-06-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Jun 2014 19:07:58 +0200
In-Reply-To: <1403626964.10831.12.camel@jlt4.sipsolutions.net> (sfid-20140624_182313_006352_507DF583)
References: <1403626964.10831.12.camel@jlt4.sipsolutions.net>
	 (sfid-20140624_182313_006352_507DF583)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-24 at 18:22 +0200, Johannes Berg wrote:

> The biggest thing here is probably Arik's TDLS rework, beyond that we
> have smaller improvements and features like David's scanning IE thing,

The latter seems to cause some issues with the ath9k multi-channel code,
I didn't realize you'd merged that in.

The fix is not very difficult, so maybe you can just fix it when you
merge? See commit eb6a61549f530f1cc435512df3799f656094ba83 for how all
the other drivers were changed.

johannes

