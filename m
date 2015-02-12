Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35216 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbBLQie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 11:38:34 -0500
Received: by mail-oi0-f52.google.com with SMTP id u20so4077784oif.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 08:38:33 -0800 (PST)
Message-ID: <54DCD708.3070402@lwfinger.net> (sfid-20150212_173838_152599_B29E8C98)
Date: Thu, 12 Feb 2015 10:38:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?Sm9oYW5uZXMgTMO2dGhiZXJn?= <johannes@kyriasis.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce kernel panics since 3.17(?)
References: <20150212121057.GA1804@leeloo.kyriasis.com>
In-Reply-To: <20150212121057.GA1804@leeloo.kyriasis.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2015 06:10 AM, Johannes Löthberg wrote:
> Since sometime around version 3.16 or 3.17 I've been getting a lot of occasional
> kernel panics related to my wifi driver. My laptop has a Realtek RTL8188CE
> wireless card and uses the rtl8192ce driver.
>
> I have pictures of what I think is two identical kernel panics, a couple of days
> apart:
>
> https://lh4.googleusercontent.com/yjwOnrDmioCwuC8FqIXlKMiBTOXddLyJkWTiInJoX2o=w421-h569-no
>
> https://lh3.googleusercontent.com/-xM-1wSsVu4c/VKxDnlkgBbI/AAAAAAAAIng/HxtqgHgglHY/w421-h569-no/IMG_20150106_212020.jpg
>
>
> It only seems to happen when I have several days of uptime on my laptop and just
> use sleep all the time instead of shutting it down.
>
> Also I have a picture of a kernel panic that is different from the previous ones:
>
> https://lh3.googleusercontent.com/-Hj06Csglpa0/VKrI1al6QbI/AAAAAAAAImk/VzhmN-dfSB0/w657-h486-no/IMG_20150105_182236.jpg
>
>
> Not sure how to debug it really, but figured that sending in a report would be
> worth a shot.
>

What kernel were you running when you made the photos? Use the command 'uname 
-r'. When I get that information, I can then use the dump trace to determine the 
locations of the oops.

Larry


