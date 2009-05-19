Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45131 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZESORa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:17:30 -0400
Received: by fxm2 with SMTP id 2so3903049fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 07:17:30 -0700 (PDT)
Subject: Re: [BUG] Crda oopses the system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com>
References: <1241499867.4816.18.camel@maxim-laptop>
	 <43e72e890905121500k61545ff3mcdf099a08178b72c@mail.gmail.com>
	 <1242166051.26484.7.camel@maxim-laptop>
	 <43e72e890905131428r568e6f5eyd64566e993c83d8c@mail.gmail.com>
	 <1242256104.3241.4.camel@maxim-laptop>
	 <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	 <1242256950.3241.13.camel@maxim-laptop>
	 <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
	 <1242258469.3241.19.camel@maxim-laptop>
	 <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
	 <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 19 May 2009 17:17:27 +0300
Message-Id: <1242742647.23110.10.camel@ibm172>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-14 at 10:20 -0400, Bob Copeland wrote:
> On Wed, May 13, 2009 at 8:07 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >>
> >> I wish I had time to set up, an ath5k in AP mode. There are rumors that
> >> it works more or less now, then I could use the same beacon frame to
> >> test.
> >
> > It does and if it doesn't its a bug.
> 
> Just FYI, it's known to have problems if the STA uses power saving --
> ath5k never updates the beacon.  I have a patch that should work in the
> relevant bugzilla but I haven't been back to retest it (at first I
> thought it was causing hangs, but later realized the hangs were due to
> other bugs in w-t).
> 


Just to say the truth, I haven't took my laptop with me, thus I still
haven't tested this. I just happened that I has to do such.


I ether make my ath5k send same beacon at home, or bring it here for
next week.


Anyway I think it won't hurt to merge these patches anyway.


Best regards, and really sorry,
	Maxim Levitsky

