Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab2ICBBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 21:01:14 -0400
Received: by iahk25 with SMTP id k25so3609229iah.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2012 18:01:14 -0700 (PDT)
Message-ID: <50440156.5020300@lwfinger.net> (sfid-20120903_030153_967252_7183E493)
Date: Sun, 02 Sep 2012 20:01:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: coekbe <coekbe@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] rtl8192cu: completing beaconing support
References: <CAK678xg-uD6rKdcZVksAdAwMtsvmcn6GmYsSa1gWS=CNTLpenw@mail.gmail.com>  <5043E582.6070205@lwfinger.net> (sfid-20120903_010233_586023_7DF08501) <1346628057.10113.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1346628057.10113.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/02/2012 06:20 PM, Johannes Berg wrote:
>
> Just FYI -- that's not guaranteed if "iw scan" returns results, you'd
> have to run "iw scan passive" to make sure you pick up beacons rather
> than just probe responses.

That is good to know. Unfortunately, 'iw wlan0 scan passive' run as an 
unprivileged user results in "command failed: Operation not permitted (-1)". 
When I run it as root, then I get "command failed: Operation not supported 
(-95)". I am assuming that my version of iw (0.9.22) is not new enough.

When I run 'iwlist scan' in unprivileged mode, I did see the beacon, thus I got 
the right answer.

Larry


