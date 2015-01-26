Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54564 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbbAZJAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 04:00:21 -0500
Message-ID: <1422262812.1890.12.camel@sipsolutions.net> (sfid-20150126_100024_541505_8AC823BE)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Jan 2015 10:00:12 +0100
In-Reply-To: <CA+XVXfdCobu73WOdCDPLuW1XBHQ7otsJG235zwD=DJccaKN2=w@mail.gmail.com> (sfid-20150126_093721_836118_F2D189C4)
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
	 <CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com>
	 <1422260772.1890.7.camel@sipsolutions.net>
	 <CA+XVXfdCobu73WOdCDPLuW1XBHQ7otsJG235zwD=DJccaKN2=w@mail.gmail.com>
	 (sfid-20150126_093721_836118_F2D189C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-26 at 10:37 +0200, Arik Nemtsov wrote:

> >> Shouldn't you also set vht_oper->basic_mcs_set here? Of course if you
> >> have no use for it in IBSS I can add it later.
> >
> > Why would you want to require VHT rates?
> 
> Are you sure it's required and no the other way around in this case?
> As in specifying which rates are not supported.
> Not sure it means the same thing as in the HT instance.

Well, it does mean the same thing ("these rates are required") but it's
encoded in a way that you have to set it to all-ones (rather than
all-zeroes) to mean "no requirements", so in that sense you're right.

johannes

