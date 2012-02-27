Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab2B0Kzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 05:55:41 -0500
Date: Mon, 27 Feb 2012 11:55:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00] rt2800usb and RT3070 issues with 54G AP
Message-ID: <20120227105538.GE4104@redhat.com> (sfid-20120227_115545_048083_820EB6AC)
References: <20120218165631.GA2922@redhat.com>
 <1329756774.86563.YahooMailClassic@web161602.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1329756774.86563.YahooMailClassic@web161602.mail.bf1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 20, 2012 at 08:52:54AM -0800, Walter Goldens wrote:
> > Looks like this could be related with Power-Save. Seems APs
> > does not
> > handle PS well (between each ICMP packed our station is put
> > in
> > the sleep mode) . Vendor driver has  PS disabled, hence
> > problem
> > is not observable.
> > 
> > Try "iwconfig wlan0 power off" and see if it helps. 
> > 
> > Stanislaw
> 
> Hello again,
> 
> Unfortunately, disabling PS does not fix the problem:

I'm able to reproduce that problem locally, I'm adding debug
that problem to my TODO list ...

Stanislaw
