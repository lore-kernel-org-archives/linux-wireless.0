Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kramwerk.de ([62.75.162.77]:40396 "EHLO mail.kramwerk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab0LJTKT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 14:10:19 -0500
From: Florian Kriener <florian@kriener.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Subject: Re: BUG: Microcode SW error detected / Frequent disconnects
Date: Fri, 10 Dec 2010 20:10:16 +0100
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <201012101409.38146.florian@kriener.org> <AANLkTikb1Pmk3F6BL1ewrKpQaOxrG-McxbfnfTGNcZKo@mail.gmail.com> <1291994774.10280.183.camel@wwguy-ubuntu>
In-Reply-To: <1291994774.10280.183.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012102010.16921.florian@kriener.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 December 2010 16:26:14 Guy, Wey-Yi wrote:
> On Fri, 2010-12-10 at 07:27 -0700, Sedat Dilek wrote:
> > Guessing you are using a Debian kernel from experimental.
> > 'uname -a' is normally not enough, we need the Debian version
> > string. (As there was only one 2.6.36 kernel, it is clear which
> > version you have). There is now a 2.6.37-rc4 in experimental,
> > please try that. bwh has prepared -rc5 a few hours ago and it will
> > be uploaded to experimental soonish.
> > (You check out from SVN and build by yourself or wait, see
> > instructions on Debian kernel team wiki).

The full version string is 2.6.36-1~experimental.1 and I will try 2.6.37 
as soon as it hits experimental.

BTW: I have problems with this network since 2.6.32, however I did not 
see any microcode sw error messages at first.

> > Another possibility is you use compat-wireless stable or
> > bleeding-edge (in addition to your host 2.6.36 kernel).
> > 
> > All these "experiments" only to see if it is a problem in 2.6.36.
> > (Might be the Intel developers know where the problem is exactly).
> > 
> > Next question is: You have latest firmware file(s) from non-free?
> > (Or look at Intel's iwlwifi download website).

I have indeed, the version is 8.24.2.12 as you can check in the 
truncated dmesg log.

> > BTW, sometimes a full dmesg log is more helpful than a truncated
> > one.

I didn't want to post it in full for privacy reasons but I can send you 
one in full directly if you are interested. I will however have to wait 
until the problem shows up again. I don't know why, but I did not save 
the full log. Sorry.

> Looks like you have 5000 NIC device based on the firmware version.
> Please let me know the problem still happen in 2.6.36. If does, we
> can look into possible firmware problem

Yes, it is a 5300 . I guess you mean 2.6.37 and yes I will let you know.

Sincerely,
Florian.
