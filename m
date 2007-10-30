Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33469 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbXJ3LWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 07:22:08 -0400
Date: Tue, 30 Oct 2007 12:22:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Hellwig <hch@infradead.org>,
	Jeff Lee <YY_Lee@issc.com.tw>
Cc: Daniel Hazelton <dhazelton@enter.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	Luis Correia <luis.f.correia@gmail.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
Subject: Licensing of IS89C35 WLAN USB driver [was Re: rt73usb: support for
	wireless in Kohjinsha subnotebook]
Message-ID: <20071030112221.GA17586@elf.ucw.cz> (sfid-20071030_112212_450343_9E1A3044)
References: <20071023090808.GB19758@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071023090808.GB19758@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

You are listed as author of IS89C35 802.11bg WLAN USB Driver. That
driver has clear MODULE_LICENSE("GPL") tag, but not other notices.

Is it safe to assume whole sources are to be distributed under GPLv2?
(Or is it GPLv2 or later?)
								Pavel

> > there's nothing to suggest otherwise, and there's explicit:
> > 
> > #define DRIVER_AUTHOR                   "Jeff Lee<YY_Lee@issc.com.tw>"
> > #define DRIVER_DESC                             "IS89C35 802.11bg WLAN USB Driver"
> > MODULE_LICENSE("GPL");
> 
> So what about contacting the vendor and asking?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
