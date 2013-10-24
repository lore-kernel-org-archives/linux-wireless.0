Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3JXLZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 07:25:31 -0400
Date: Thu, 24 Oct 2013 13:22:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Edimax EW-7733UnD
Message-ID: <20131024112206.GB1677@redhat.com> (sfid-20131024_132535_067323_4AFF2FD2)
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com>
 <1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 23, 2013 at 03:27:49PM +0100, Gianfranco Costamagna wrote:
> Hi Kernel Wireless developers, I write here since I have an issue with this module.
> 
> 
> We bought 2 of them since they are both 2.4 and 5Ghz capable, and they seem to be powerful enough for our pourposes
> http://www.edimax.com/au/produce_detail.php?pd_id=399&pl1_id=1&pl2_id=44
> 
> 
> Anyway there is a problem, that the linux kernel seems to be not supporting them
> 
> I tried following this guide
> http://wikidevi.com/wiki/Edimax_EW-7733UnD
> rt3573sta, possibly rt5572sta, and future support in rt2800usb "uhosg's patchset adding support, may be in by k3.12"
> but at this moment it is showing an interface with one of them (I cannot connect to anything, the interface shown seems to be incorrect), with another I get a kernel anic and with the third one doesn't work at all.
> 
> lsusb |grep Edimax
> 
> Bus 002 Device 002: ID 7392:7733 Edimax Technology Co., Ltd 

I have that exect device and it works ok here, but I'm using 
wireless-testing tree. So perhaps you should try install that
tree or use backports .

Stanislaw
