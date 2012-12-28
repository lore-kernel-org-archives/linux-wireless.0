Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54015 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab2L1CTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 21:19:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ToPYK-00026b-1i
	for linux-wireless@vger.kernel.org; Fri, 28 Dec 2012 03:20:04 +0100
Received: from pool-72-79-128-100.sctnpa.east.verizon.net ([72.79.128.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2012 03:20:04 +0100
Received: from pagea by pool-72-79-128-100.sctnpa.east.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2012 03:20:04 +0100
To: linux-wireless@vger.kernel.org
From: Alden Page <pagea@allegheny.edu>
Subject: Re: bugreport Connectivity problems with rtl8192cu
Date: Fri, 28 Dec 2012 02:18:53 +0000 (UTC)
Message-ID: <loom.20121228T030252-692@post.gmane.org> (sfid-20121228_031956_076750_74927515)
References: <CABLZTyB12FX3e_yAoH7XOfhhA-pcv4GqzpfkBDNi64jdh5eCXA@mail.gmail.com> <50DCE1F3.806@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Larry Finger <Larry.Finger@...> writes:

> What is this doing here? You need to have either the in-kernel
 driver available, or the vendor driver. This bit shows you
> have both.

Since I was having a lot of trouble with the in-kernel driver,
I tried the vendor driver. I went to some lengths to get it to
compile and install in thenew kernel. Unfortunately, this was 
before I referred to the documentation and read that it supports
x86 only.

Apparently I didn't uninstall the broken vendor driver entirely
as I thought I did. I will try to clean it out. Still, the
problems that I described were present before I installed it.

