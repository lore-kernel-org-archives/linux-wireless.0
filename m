Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43031 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1DFPpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 11:45:19 -0400
Date: Wed, 6 Apr 2011 11:39:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gottfried Haider <gottfried.haider@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce: odd ping behavior
Message-ID: <20110406153918.GF11941@tuxdriver.com>
References: <BANLkTimnXJGy07-8gt=O7ruH-Hyt=NqtuQ@mail.gmail.com>
 <4D9B5473.6040003@lwfinger.net>
 <BANLkTi=ueo0Vm5VPRh=LMCQ-huGzXMyvFQ@mail.gmail.com>
 <20110406145700.GC11941@tuxdriver.com>
 <BANLkTikpDaEpHaCBOT2vE9=j9Ukvmo0gpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTikpDaEpHaCBOT2vE9=j9Ukvmo0gpw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 06, 2011 at 05:05:19PM +0200, Gottfried Haider wrote:
> >> Thanks for testing. I had hoped that the ping results could make a
> >> light go on somewhere..
> >
> > FWIW, the behaviour you described sounds a lot like bufferbloat.
> 
> Thanks John, I was looking forward to reading this soon.
> 
> But (without knowing about bufferbloat): would this manifest itself
> only on the single network adapter? I am having no issues at all with
> a Broadcom card on the same network or on the same machine when using
> a USB-tethered phone to access the WiFi..

It depends on where the bottlenecks are in the network, and where the
"dark" buffers are too.  I'm not sure how big the hardware tx ring
is for the rtl8192ce for example, or if it has any problems with
retries or whatever.  I was mostly just observing that what you were
describing sounded like typical bufferbloat (i.e. high latency leading
to full big slow buffers) behavior. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
