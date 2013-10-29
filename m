Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3J2IDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 04:03:47 -0400
Message-ID: <1383033823.14377.1.camel@jlt4.sipsolutions.net> (sfid-20131029_090354_403437_B70F68A3)
Subject: Re: iwlegacy (4965) - what would 0x8000 as the completed TX rate
 indicate?
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 29 Oct 2013 09:03:43 +0100
In-Reply-To: <CAJ-Vmomsv52xc6-rwaBy9aZUsN3BaPeRTDBu8+bn2ov_Asb=1A@mail.gmail.com> (sfid-20131028_202445_048613_6F806293)
References: <CAJ-Vmok4rDn1Q5qCU2Oz=CVsqkJvYC0D+CmQL+WpwU+9qKHzrw@mail.gmail.com>
	 <1382968966.17956.15.camel@jlt4.sipsolutions.net>
	 <CAJ-Vmomsv52xc6-rwaBy9aZUsN3BaPeRTDBu8+bn2ov_Asb=1A@mail.gmail.com>
	 (sfid-20131028_202445_048613_6F806293)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 12:24 -0700, Adrian Chadd wrote:

> >> So, any ideas what that 0x8000 rate in the rate completion means?
> >
> > I think that just means it used the other antenna and rate 0, since the
> > bits 0x1c000 contain the antenna bitmap that was used (up to three can
> > be used for each transmission)
> 
> Well, what's rate=0 mean?
> 
> And 0x8000 is bit 11 set, which is HT40. I definitely don't have HT40 enabled.

0x8000 is bit 15 set, which means "antenna B", I think?

But then I can't seem to figure out what rate=0 means either. Should be
an OFDM rate (bit 9 not set) but 0 isn't a valid OFDM rate value. Hmm.

johannes

