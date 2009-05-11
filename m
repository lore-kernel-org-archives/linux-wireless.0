Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47033 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZEKBkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 21:40:19 -0400
Received: by ewy24 with SMTP id 24so3132055ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2009 18:40:18 -0700 (PDT)
Date: Mon, 11 May 2009 03:40:16 +0200
From: "Christoph .J Thompson" <cjsthompson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Correia <luis.f.correia@gmail.com>,
	Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>,
	linux-wireless@vger.kernel.org
Subject: Re: rt73usb Access point status
Message-Id: <20090511034016.17f0deb0.cjsthompson@gmail.com>
In-Reply-To: <1241085910.27613.16.camel@johannes.local>
References: <wfbpqkvlm0.fsf@calligramme.charmers>
	<wfzldytr8l.fsf@calligramme.charmers>
	<efe7343f0904300251q4650d17nb062cc28b011580d@mail.gmail.com>
	<efe7343f0904300258u7d29ff3cu9ca8ea3b3038ebab@mail.gmail.com>
	<1241085910.27613.16.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 30 Apr 2009 12:05:10 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > The solution they have found is not optimal, b ut works in their scenario.
> > 
> > You will need to modify hostapd, according to this blog post:
> > http://eznemegy.blog.hu/2008/12/14/using_rt2x00_wireless_driver_with_hostapd
>
> Based on that information, I have removed the "Yes (under development)"
> note from the driver page since it doesn't really support it... In fact,
> I'm surprised it works even with that hack since hostapd usually polls
> the station with nullfunc frames and waits for an ack.
> 
> johannes
> 

Another success story with this hack:

I've been using the very same USB dongle Jon is speaking about with a patched hostapd on my AP for over 2 months and so far I didn't have any problems whatsoever with it. WPA2 works fine too. I'm using stock Linux 2.6.29.2 and hostapd 0.6.9 patched. The client machine is never far away from the AP (so that limits possible problems) and it's also running stock Linux 2.6.29.2. The client's wireless card is an ath5k.

-- 
Christoph .J Thompson <cjsthompson@gmail.com>
