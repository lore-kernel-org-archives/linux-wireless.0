Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51301 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1K2QYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 11:24:03 -0500
Received: by ywa9 with SMTP id 9so4254538ywa.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 08:24:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322338254.4283.2.camel@jlt3.sipsolutions.net>
References: <CA++WF2O0WjyqU0HEGR1XE9xDFzR+sxRboVWexRCMPi8okOVkkA@mail.gmail.com>
	<1322338254.4283.2.camel@jlt3.sipsolutions.net>
Date: Tue, 29 Nov 2011 08:24:01 -0800
Message-ID: <CA++WF2PqP8_pO7isKphSnOmMzHqwhaBWvHqZengyXCpSZXyO3A@mail.gmail.com> (sfid-20111129_172408_911055_91D38CD0)
Subject: Re: Converting ipw2x00 driver to mac80211 framework
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> What do you think is the best way of converting the ipw2x00 driver to
>> the mac80211 framework?
>
> TBH, I'm not even sure it is a good idea to do that.  Given that the
> driver is quite old, nobody really knows how the hardware works any
> more, it likely has quite a different operating model from mac80211, I
> wouldn't recommend attempting this. I'm not even sure it is possible at
> all.
>
> It would be much less risky to convert the entire thing to cfg80211, I
> think, basically just replacing the configuration layer in libipw_wx.c
> with a cfg80211 based one.

Thanks for directions, I will take a look.

Stanislav.
