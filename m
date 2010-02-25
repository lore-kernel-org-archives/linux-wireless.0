Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f177.google.com ([209.85.223.177]:53423 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172Ab0BYSFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 13:05:31 -0500
Received: by iwn7 with SMTP id 7so5388580iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 10:05:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267087684.3796.0.camel@jlt3.sipsolutions.net>
References: <20100202000934.GA19847@sortiz.org>
	 <201002151146.48156.holgerschurig@gmail.com>
	 <cdd918981002240005o1fa50956yfb2a692716c06a55@mail.gmail.com>
	 <1267054502.6162.9.camel@localhost.localdomain>
	 <cdd918981002250042m16cdf34ap8305ed2fbfd7804d@mail.gmail.com>
	 <1267087684.3796.0.camel@jlt3.sipsolutions.net>
Date: Thu, 25 Feb 2010 10:05:30 -0800
Message-ID: <c1545bb51002251005o396130e9g906e5efff024c78@mail.gmail.com>
Subject: Re: [PATCH] libertas: cfg80211 support
From: Andrey Yurovsky <yurovsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David MOUSSAUD <d.moussaud@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <holgerschurig@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 25, 2010 at 12:48 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-02-25 at 09:42 +0100, David MOUSSAUD wrote:
>> Thanks for the explication.
>> Do you know an other sdio chipset that would do the job ?
>
> libertas_tf driver has AP iirc.

Yes but it only supports one variant with USB (88w8388) and special
firmware, there's no SDIO equivalent.

The only soft-MAC/mac80211 hardware/driver that I can think of that
has an SDIO variant right now is the TI wl12xx stuff but I don't know
anything about it or whether it can do enough to support AP via
mac80211.

  -Andrey
