Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr18.hinet.net ([168.95.4.118]:59333 "EHLO msr18.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1GRJEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 05:04:13 -0400
Date: Mon, 18 Jul 2011 17:01:32 +0800
From: Ali Bahar <ali@internetdog.org>
To: Stefan Assmann <sassmann@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
Message-ID: <20110718090132.GA8636@internetdog.org> (sfid-20110718_110416_492562_7021A924)
Reply-To: ali@internetdog.org
References: <4E2051F3.20103@redhat.com>
 <4E205984.5040803@lwfinger.net>
 <4E23E56C.9000202@redhat.com>
 <20110718082709.GA8390@internetdog.org>
 <4E23F2E0.3050200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E23F2E0.3050200@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 18, 2011 at 10:46:24AM +0200, Stefan Assmann wrote:
> On 18.07.2011 10:27, Ali Bahar wrote:

> > How are you seeing that (to quote the above) "the network goes down"
> > and that the driver reports that "it's connected"? 
> > (Typically, I use only ifconfig and iwconfig, but those don't monitor
> > the connection.)
> 
> OK, so I first recognized the problem when I rebooted my AP and the host

Got it. Now I understand.


> in question didn't get back online. Checking the host itself it seemed
> that the network is doing fine, ifconfig showed the interface has an IP
> but I couldn't ping any hosts. After an ifdown ; ifup cycle everything
> was back to normal.
> I pulled the power from the AP, waited a few minutes and checked back.
> The ifconfig output still showed that the device had its IP.

It would (retain its IP#), unless if wpa_supplicant steps in.
Frankly, I am not familiar enough with the/any monitoring behaviour of
wpa_supplicant to know whether it'd step in. AFAIK it should and it
would.


 
> >> occurred in dmesg. The interface even keeps it's IP although the wireless
> >> was long gone.
> > 
> > So ifconfig shows the IP#. I'm assuming that it no longer shows a
> > state of "UP".
> 
> I would assume so, but I'll have to reproduce to make sure.

I don't need this anymore/yet.


 

> > This'd seem an inane question, but I must ask: What exactly do you
> > mean by the wireless being "gone"? Which GUI/utility/effect do you
> > see? Is it a powered-down AP, roaming, iwconfig's output, or what?
> 
> I pulled the power from the AP. :)

Thought so. Thanks.

I'll try to reproduce this here.

thanks much,
ali
