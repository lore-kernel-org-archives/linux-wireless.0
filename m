Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34297 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078Ab0LTWHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 17:07:14 -0500
Received: by qyk12 with SMTP id 12so3717242qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 14:07:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292879085.20560.6.camel@t-dhlii>
References: <0826983CC0CB074798C42E77D8ACD07F01AE4A@pdtms1.pdt.com>
	<1292843841.13129.9.camel@chilepepper>
	<0826983CC0CB074798C42E77D8ACD07F01AEA8@pdtms1.pdt.com>
	<1292879085.20560.6.camel@t-dhlii>
Date: Mon, 20 Dec 2010 17:07:13 -0500
Message-ID: <AANLkTin2cTCT7aZ7_EX+7ZjSoXdt28wKZzBM7VVXyj25@mail.gmail.com>
Subject: Re: WL1271
From: Bob Copeland <me@bobcopeland.com>
To: "David Lynch Jr." <dhlii@dlasys.net>, elvis.dowson@mac.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 20, 2010 at 4:04 PM, David Lynch Jr. <dhlii@dlasys.net> wrote:
>        Is it reasonable to assume that if I add the WL1271 to the Android
> 2.6.32 kernel tree using compat-wireless that it will properly integrate
> with Android ?

No; last I checked, Android has all kinds of hacks in the wext layer to
work with their UI.  But in the mainline, new features are added to nl80211
and wext is deprecated.

> If not could someone point me towards resources specific
> to Android's wireless implimentation ?

There's this, but it's a bit out of date:

    http://bobcopeland.com/android_wifi.html

Also I have a few Android ports/makefiles for wireless utitilies here:

    https://github.com/bcopeland

>From there, you can follow github forks and see what the community
is doing with them.

My two cents: it's easier to just use the Android code, but it's worth
a whole lot more in the long run to work towards a mainline-friendly,
nl80211-based wireless system.  That would make support of additional
mainline wireless drivers much easier.

-- 
Bob Copeland %% www.bobcopeland.com
