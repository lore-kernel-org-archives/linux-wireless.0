Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm32-vm1.bullet.mail.ir2.yahoo.com ([212.82.97.97]:41681 "EHLO
	nm32-vm1.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab3JXLcT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 07:32:19 -0400
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com> <1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com> <20131024112206.GB1677@redhat.com>
Message-ID: <1382614336.89589.YahooMailNeo@web171804.mail.ir2.yahoo.com> (sfid-20131024_133222_240534_45E2654F)
Date: Thu, 24 Oct 2013 12:32:16 +0100 (BST)
From: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Reply-To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Subject: Re: Edimax EW-7733UnD
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20131024112206.GB1677@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Il Giovedì 24 Ottobre 2013 13:25, Stanislaw Gruszka <sgruszka@redhat.com> ha scritto:

On Wed, Oct 23, 2013 at 03:27:49PM +0100, Gianfranco Costamagna wrote:
>
>> Hi Kernel Wireless developers, I write here since I have an issue with this module.
>> 
>> 
>> We bought 2 of them since they are both 2.4 and 5Ghz capable, and they seem to be powerful enough for our pourposes
>> http://www.edimax.com/au/produce_detail.php?pd_id=399&pl1_id=1&pl2_id=44
>> 
>> 
>> Anyway there is a problem, that the linux kernel seems to be not supporting them
>> 
>> I tried following this guide
>> http://wikidevi.com/wiki/Edimax_EW-7733UnD
>> rt3573sta, possibly rt5572sta, and future support in rt2800usb "uhosg's patchset adding support, may be in by k3.12"
>> but at this moment it is showing an interface with one of them (I cannot connect to anything, the interface shown seems to be incorrect), with another I get a kernel anic and with the third one doesn't work at all.
>> 
>> lsusb |grep Edimax
>> 
>> Bus 002 Device 002: ID 7392:7733 Edimax Technology Co., Ltd 
>
>I have that exect device and it works ok here, but I'm using 
>wireless-testing tree. So perhaps you should try install that
>tree or use backports .


Wonderful! I don't really understand what do you mean with backports, are you referring to "linux kernel backports" right?

So I can choose the backport source or to checkout and build the wireless-testing tree.

Just as information, how long will it take to have it into the stable mainline?

How does the merge works?
(just because I don't want to build a custom kernel if not really needed I use the rc kernels packaged by ubuntu team
http://kernel.ubuntu.com/~kernel-ppa/mainline/ )


many thanks

Gianfranco


>
>Stanislaw
>
>
>
>
