Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35980 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0LZMhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 07:37:07 -0500
Received: by qyj19 with SMTP id 19so9620498qyj.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Dec 2010 04:37:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293366263.3537.1.camel@jlt3.sipsolutions.net>
References: <20101226112404.31775.77854.stgit@fate.lan>
	<1293366263.3537.1.camel@jlt3.sipsolutions.net>
Date: Sun, 26 Dec 2010 13:37:06 +0100
Message-ID: <AANLkTim_G3Q8tkNepERTWT-0j118ZxTbN==Z9ufCUWRa@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] zd1211rw: add support for AP mode
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/26 Johannes Berg <johannes@sipsolutions.net>:
> On Sun, 2010-12-26 at 13:24 +0200, Jussi Kivilinna wrote:
>
>>  1. I have not been able to trigger bc/mc buffering. I have tested with
>>     b43 and rndis_wlan stations.
>
> Put the stations into powersave mode. I guess neither of those actually
> support that, though you might easily pretend to support powersave in
> b43 -- even if it won't save power it'll have the AP trigger this.
>
> However, bc/mc buffering is a very important feature of AP mode, so you
> shouldn't try to support AP mode w/o it.

What do bc and mc stand for?

-- 
Rafał
