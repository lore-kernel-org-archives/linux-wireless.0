Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2831 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030326AbXCLPCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 11:02:45 -0400
Date: Mon, 12 Mar 2007 10:37:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Jeff Williams <angelbane@ou.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: Airgo Networks Wireless Card Linux support
Message-ID: <20070312143747.GA8878@tuxdriver.com>
References: <Pine.LNX.4.64.0703091340080.380@dulcinea> <200703120038.59689.flamingice@sourmilk.net> <1173676135.30756.27.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173676135.30756.27.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2007 at 01:08:55AM -0400, Pavel Roskin wrote:
> On Mon, 2007-03-12 at 00:38 -0400, Michael Wu wrote:
> 
> > Well, if you're willing to write specs, I'll help write the driver. Silly 
> > question first however - have you asked Airgo Networks if they are willing to 
> > help with a Linux driver?
> 
> From
> http://searchopensource.techtarget.com/originalContent/0,289142,sid39_gci1134910,00.html
> 
> "Joe felt that Airgo Networks should be commended for its honorable
> handling of OSS, but he still had no luck there. When he called the
> company, he found out that no Linux drivers will be available for the
> Airgo chip set until late 2005 or early 2006."
> 
> Oh well.  At least they are not against the idea of Linux drivers.

A reply from 13 February 2007 to a query a made a day or two before that:

	"Thank you for your inquiry. At this time we do not have Linux drivers
	for Airgo products. Please check back on our web for new products and
	updates. With focus on delivering our next generation of solutions, we
	are not able to support outside development efforts." [1]

At this point I have to recommend that all Linux users avoid Airgo
hardware unless/until either Airgo decides to support its hardware or
someone is successful with a reverse engineering effort.  I expect
that there will be other .11n hardware supported on Linux in the
near future.

Regarding reverse engineering, please do follow the example set by the
bcm43xx team.  We don't need any more drivers of questionable origin.

Thanks,

John

[1] To which I replied "If you don't have time to support me, how will
you ever have time to write your own driver?"  Of course, I have had
no response to that one.
-- 
John W. Linville
linville@tuxdriver.com
