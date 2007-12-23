Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:63126 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXLWI2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 03:28:05 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1789906wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2007 00:28:05 -0800 (PST)
Message-ID: <1ba2fa240712230028l1759abdcsd2a1bd9cd9fa36e7@mail.gmail.com> (sfid-20071223_082817_428171_A4B28742)
Date: Sun, 23 Dec 2007 10:28:05 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add unified BSS configuration
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1198358103.6630.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1198109817.16241.7.camel@johannes.berg>
	 <1ba2fa240712221255q2daee8eehf84e1a5829ad2ac0@mail.gmail.com>
	 <1198358103.6630.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 22, 2007 11:15 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > Except assoc id we need also TSF from the beacon before we can drop
> > the sniffing code.
>
> What would you need the TSF for? You don't know how long afterwards you
> got it anyway, no?

Actually I need all the timing info Beacon Interval, Listen Interval,
DTIM and TSF from the last beacon.
The TSF is just a time stamp when this info was taken.
Tomas

> johannes
>
