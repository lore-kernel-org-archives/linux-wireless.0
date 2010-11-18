Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43664 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0KRLhg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 06:37:36 -0500
Received: by iwn35 with SMTP id 35so3401550iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 03:37:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290028078.8522.62.camel@dcbw.foobar.com>
References: <AANLkTik+BWQdU4hhKN7yfgOdJuQXopvYr4Z59RTntqSW@mail.gmail.com>
 <1289607742.21000.23.camel@dcbw.foobar.com> <AANLkTi=1RFZwRYvA=VfuKTQS6YwZkTv17Q0nnWnQW3Hq@mail.gmail.com>
 <AANLkTinKMfu2SX2fymUDi3JooAwKZv7=41BQBywR3pVe@mail.gmail.com> <1290028078.8522.62.camel@dcbw.foobar.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 18 Nov 2010 22:37:15 +1100
Message-ID: <AANLkTinc7F8pCXbKBf3-Nyeb05GQ=_DX+EsRxjkzO9ua@mail.gmail.com>
Subject: Re: Bringing up Marvell 88W8300
To: Dan Williams <dcbw@redhat.com>
Cc: Denis Kirjanov <kirjanov@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	dwmw2@infradead.org, David.Woodhouse@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 08:07, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2010-11-17 at 20:15 +0300, Denis Kirjanov wrote:
>> >
>> > I will try to load the firmware that comes with the driver source.
>> >
>> >> Does that sound like a plan?  I have no time for it, but I'm happy to
>> >> put the driver up somewhere that others can make use of it.  I'll
>> >> recheck the provenience of the driver but it's got MODULE_LICENSE("GPL")
>> >> and GPL headers all over, including on the firmware file.  I might have
>> >> grabbed it off the Extranet but I'll check.
>> >>
>> Marvell firmware is OK for me and I can successfully boot in .
>> I believe that we can now port driver to the new wireless stuff such
>> as cfg80211.
>
> Yeah, that's the driver, the MSI thing or whatever linked from openwrt
> forums.  Basically, I think we should get that driver working so we know
> that *something* works on these cards, and then use it and mwl8k as a
> guide to writing a new mac80211 driver for the 8335.

I have a card with this chipset (A Netgear WG311v3) and have a spare
machine to test it in. I'm quite happy to test the driver at any stage
of development.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
