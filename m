Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43899 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469AbZEHRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 13:15:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 May 2009 10:15:01 -0700
Date: Fri, 8 May 2009 10:15:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jason Daly <jason2@primarykey.ca>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] New kernel recommendations for ath9k
Message-ID: <20090508171514.GA8123@tesla>
References: <43e72e890905070104u59eebcceu18718a733e388cc9@mail.gmail.com> <4A02B1CA.3060708@hiramoto.org> <43e72e890905071020v26857c52p3abea96be04ef1d9@mail.gmail.com> <6818156.7441241761835737.JavaMail.james@prod3.pk.lan> <1241773324.1567.33.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1241773324.1567.33.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 08, 2009 at 02:02:04AM -0700, Johannes Berg wrote:
> On Sat, 2009-05-09 at 01:50 -0400, Jason Daly wrote:
> > Thanks for the kernel info.
> >
> > How do you configure hostapd to work in N mode with ath9k?  Currently
> > the hw_mode parameter found in hostapd.conf does not accept anything
> > greater than g.
> 
> N isn't "greater than" G. N is more features than G. Just set the N
> options in the config file. You may need a git hostapd, I don't know for
> sure.
> 
> Also, please set your clock and timezone correctly _before_ you say
> "thank you"!. You have posted on
>         Sat, 09 May 2009 01:50:12 -0400 (07:50 CEST)
> 
> which is clearly impossible.
> 
Also check out:

http://wireless.kernel.org/en/users/Documentation/hostapd

  Luis
