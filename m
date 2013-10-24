Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573Ab3JXLlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 07:41:12 -0400
Date: Thu, 24 Oct 2013 13:37:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Edimax EW-7733UnD
Message-ID: <20131024113748.GD1677@redhat.com> (sfid-20131024_134115_575667_0F147178)
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com>
 <1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>
 <20131024112206.GB1677@redhat.com>
 <1382614336.89589.YahooMailNeo@web171804.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1382614336.89589.YahooMailNeo@web171804.mail.ir2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 24, 2013 at 12:32:16PM +0100, Gianfranco Costamagna wrote:
> 
> 
> Il Giovedì 24 Ottobre 2013 13:25, Stanislaw Gruszka <sgruszka@redhat.com> ha scritto:
> 
> On Wed, Oct 23, 2013 at 03:27:49PM +0100, Gianfranco Costamagna wrote:
> >
> >> Hi Kernel Wireless developers, I write here since I have an issue with this module.
> >> 
> >> 
> >> We bought 2 of them since they are both 2.4 and 5Ghz capable, and they seem to be powerful enough for our pourposes
> >> http://www.edimax.com/au/produce_detail.php?pd_id=399&pl1_id=1&pl2_id=44
> >> 
> >> 
> >> Anyway there is a problem, that the linux kernel seems to be not supporting them
> >> 
> >> I tried following this guide
> >> http://wikidevi.com/wiki/Edimax_EW-7733UnD
> >> rt3573sta, possibly rt5572sta, and future support in rt2800usb "uhosg's patchset adding support, may be in by k3.12"
> >> but at this moment it is showing an interface with one of them (I cannot connect to anything, the interface shown seems to be incorrect), with another I get a kernel anic and with the third one doesn't work at all.
> >> 
> >> lsusb |grep Edimax
> >> 
> >> Bus 002 Device 002: ID 7392:7733 Edimax Technology Co., Ltd 
> >
> >I have that exect device and it works ok here, but I'm using 
> >wireless-testing tree. So perhaps you should try install that
> >tree or use backports .
> 
> 
> Wonderful! I don't really understand what do you mean with backports, are you referring to "linux kernel backports" right?

Yes.

> So I can choose the backport source or to checkout and build the wireless-testing tree.
> 
> Just as information, how long will it take to have it into the stable mainline?

Current wireless-testing content will be available on 3.13 ,
though I think that device should also work on 3.12 .

Stanislaw  
