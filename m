Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kanga.kvack.org ([66.96.29.28]:57701 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965632AbXC1SFB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 14:05:01 -0400
Date: Wed, 28 Mar 2007 15:04:13 -0300
From: Marcelo Tosatti <marcelo@kvack.org>
To: Pavel Roskin <proski@gnu.org>
Cc: David Young <dyoung@pobox.com>, linux-wireless@vger.kernel.org,
	Scott Raynel <scottraynel@gmail.com>, radiotap@mail.ojctech.com
Subject: Re: [Radiotap] Re: RFC: radiotap discrepancy in Linux vs OpenBSD
Message-ID: <20070328180413.GC17793@dmt>
References: <20070325232416.64xwkc0kw04oosg0@webmail.spamcop.net> <20070326033729.GG31621@che.ojctech.com> <1174949149.28132.49.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1174949149.28132.49.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 26, 2007 at 06:45:49PM -0400, Pavel Roskin wrote:
> On Sun, 2007-03-25 at 22:37 -0500, David Young wrote:
> 
> > > One is found in the current wireless-2.6.git:
> > > 
> > >         IEEE80211_RADIOTAP_RX_FLAGS = 14,
> > >         IEEE80211_RADIOTAP_TX_FLAGS = 15,
> > >         IEEE80211_RADIOTAP_RTS_RETRIES = 16,
> > >         IEEE80211_RADIOTAP_DATA_RETRIES = 17,
> > 
> > These fields are slated to become part of the standard, I just haven't got
> > around to updating the manual page, yet.  I have time to do that tonight.
> 
> OK.  I was wrong to assume that non-standard fields were introduced on
> the Linux side.

I mentioned those in the past to David Young, but I forgot to resend
them to the radiotap list. 

>From what I gather he's OK with them.
