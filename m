Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbXJ3POI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 11:14:08 -0400
Subject: Re: Licensing of IS89C35 WLAN USB driver [was Re: rt73usb: support
	for wireless in Kohjinsha subnotebook]
From: Dan Williams <dcbw@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Lee <YY_Lee@issc.com.tw>,
	Daniel Hazelton <dhazelton@enter.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Luis Correia <luis.f.correia@gmail.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
In-Reply-To: <20071030112221.GA17586@elf.ucw.cz>
References: <20071023090808.GB19758@infradead.org>
	 <20071030112221.GA17586@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 11:11:59 -0400
Message-Id: <1193757119.29187.17.camel@localhost.localdomain> (sfid-20071030_151412_884224_69D9FBB1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-10-30 at 12:22 +0100, Pavel Machek wrote:
> Hi!
> 
> You are listed as author of IS89C35 802.11bg WLAN USB Driver. That
> driver has clear MODULE_LICENSE("GPL") tag, but not other notices.
> 
> Is it safe to assume whole sources are to be distributed under GPLv2?
> (Or is it GPLv2 or later?)

Pavel,

I sent mail as you requested on Sunday to Jeff Lee but haven't heard
back yet.  I can't find any generic contact email addresses for ISSC
Taiwan or the Italian company that produced the adapter in question,
unfortunately.

Dan

> 								Pavel
> 
> > > there's nothing to suggest otherwise, and there's explicit:
> > > 
> > > #define DRIVER_AUTHOR                   "Jeff Lee<YY_Lee@issc.com.tw>"
> > > #define DRIVER_DESC                             "IS89C35 802.11bg WLAN USB Driver"
> > > MODULE_LICENSE("GPL");
> > 
> > So what about contacting the vendor and asking?
> 

