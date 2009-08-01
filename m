Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60831 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZHAIfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 04:35:37 -0400
Received: by fxm17 with SMTP id 17so1754959fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 01:35:35 -0700 (PDT)
Message-ID: <4A73FE55.5020306@gmail.com>
Date: Sat, 01 Aug 2009 10:35:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
References: <20090731181020.GE7963@makis> <20090801054649.GA8390@makis>	 <4A73FA8D.5030804@gmail.com>	 <1249114918.26584.18.camel@johannes.local>	 <4A73FBBD.3070507@gmail.com> <1249115316.2007.0.camel@johannes.local> <40f31dec0908010131q678f03d2x4ba7b6d5d1b51ff5@mail.gmail.com>
In-Reply-To: <40f31dec0908010131q678f03d2x4ba7b6d5d1b51ff5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2009 10:31 AM, Nick Kossifidis wrote:
> 2009/8/1 Johannes Berg <johannes@sipsolutions.net>:
>> time_is_after_jiffies() or so.
...
> Where can i find documentation on this ?

I wouldn't say there is anything else than include/linux/jiffies.h.
