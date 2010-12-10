Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49874 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab0LJP1a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 10:27:30 -0500
Subject: Re: BUG: Microcode SW error detected / Frequent disconnects
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: Florian Kriener <florian@kriener.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikb1Pmk3F6BL1ewrKpQaOxrG-McxbfnfTGNcZKo@mail.gmail.com>
References: <201012101409.38146.florian@kriener.org>
	 <AANLkTikb1Pmk3F6BL1ewrKpQaOxrG-McxbfnfTGNcZKo@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 10 Dec 2010 07:26:14 -0800
Message-Id: <1291994774.10280.183.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi 

On Fri, 2010-12-10 at 07:27 -0700, Sedat Dilek wrote:
> On Fri, Dec 10, 2010 at 2:09 PM, Florian Kriener <florian@kriener.org> wrote:
> > Dear Intel wireless experts,
> >
> > when connecting to a certain network I always get a lot of network
> > hangs, which can sometimes be solved temporarily by reconnecting to that
> > network. The cause seems to be a microcode software error. At leat, that
> > is what dmesg shows. I attached a piece of it.
> >
> > The access point in question is a speedport w503v, which is a Telekom
> > (German ISP) branded AVM or Arcadyan dsl router. It is located in a WLAN
> > polluted area with approx. 45 networks nearby. Most of them are between
> > channels 6 and 11. The access point in question is somehow seated at
> > channel 10, which I cannot change.
> >
> > % uname -a
> > Linux nanuk 2.6.36-trunk-amd64 #1 SMP Wed Oct 27 14:28:29 UTC 2010
> > x86_64 GNU/Linux
> >
> 
> Guessing you are using a Debian kernel from experimental.
> 'uname -a' is normally not enough, we need the Debian version string.
> (As there was only one 2.6.36 kernel, it is clear which version you have).
> There is now a 2.6.37-rc4 in experimental, please try that.
> bwh has prepared -rc5 a few hours ago and it will be uploaded to
> experimental soonish.
> (You check out from SVN and build by yourself or wait, see
> instructions on Debian kernel team wiki).
> 
> Another possibility is you use compat-wireless stable or bleeding-edge
> (in addition to your host 2.6.36 kernel).
> 
> All these "experiments" only to see if it is a problem in 2.6.36.
> (Might be the Intel developers know where the problem is exactly).
> 
> Next question is: You have latest firmware file(s) from non-free?
> (Or look at Intel's iwlwifi download website).
> 
> BTW, sometimes a full dmesg log is more helpful than a truncated one.


Looks like you have 5000 NIC device based on the firmware version.
Please let me know the problem still happen in 2.6.36. If does, we can
look into possible firmware problem

Thanks
Wey

