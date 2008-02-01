Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:47589 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbYBAV2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 16:28:01 -0500
Received: by wa-out-1112.google.com with SMTP id v27so912558wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 13:28:00 -0800 (PST)
Message-ID: <1ba2fa240802011328n1430c819q1084b9c76a30b3e1@mail.gmail.com> (sfid-20080201_212809_941641_5CB2A89F)
Date: Fri, 1 Feb 2008 23:28:00 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless mini-summit agenda proposals?
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1201896674.4188.74.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080131162514.GC6413@tuxdriver.com>
	 <1201882577.4188.68.camel@johannes.berg>
	 <40f31dec0802011107n3389bbc5l2f43be0f6111d222@mail.gmail.com>
	 <1201896674.4188.74.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 10:11 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > Plzzz someone explain how WMM is implemented in mac80211 and suggest
> > some tests so we can be sure we implement it correctly, we really want
> > to add multiqueue support in ath5k ;-)
>
> Well nobody knows ;)
There is a certification plan for that under WiFi with tests.
The implementation has some holes but it's passing tests. One glitch I
know that the priority scheduler is definitely not working correctly
in hight loads. and you better have 4 hardware queues to comply with
specification. In that case it's better to have RR scheduler instead
of what is there now.

> > Also it would be great if someone explained what's new in
> > 802.11n/802.11s and what drivers are expected to do (i think on the
> > previous summit there was a talk about encrypted management frames, do
> > we have a plan for that ?).
>
> There's no 11s support yet, the cozybit guys never came forward with a
> second patchset after we commented on their first. 11w (encrypted
> management frames) is pretty straight forward, we add the new
> "encryption" algorithm and wpa_supplicant does the rest (in fact, it
> already has code)
>
> johannes
>
