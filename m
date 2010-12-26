Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0LZMY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 07:24:26 -0500
Subject: Re: [RFC PATCH 0/6] zd1211rw: add support for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
In-Reply-To: <20101226112404.31775.77854.stgit@fate.lan>
References: <20101226112404.31775.77854.stgit@fate.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Dec 2010 13:24:23 +0100
Message-ID: <1293366263.3537.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-12-26 at 13:24 +0200, Jussi Kivilinna wrote:

>  1. I have not been able to trigger bc/mc buffering. I have tested with
>     b43 and rndis_wlan stations.

Put the stations into powersave mode. I guess neither of those actually
support that, though you might easily pretend to support powersave in
b43 -- even if it won't save power it'll have the AP trigger this.

However, bc/mc buffering is a very important feature of AP mode, so you
shouldn't try to support AP mode w/o it.

johannes

