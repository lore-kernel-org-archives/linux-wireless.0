Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LEWHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 17:07:38 -0500
Message-ID: <1386281254.4182.24.camel@jlt4.sipsolutions.net> (sfid-20131205_230742_058858_0D8BEA5B)
Subject: Re: Using wmediumd in kernel 3.10
From: Johannes Berg <johannes@sipsolutions.net>
To: Dani Camps <danicamps81@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Dec 2013 23:07:34 +0100
In-Reply-To: <1386279479.16148.YahooMailNeo@web172701.mail.ir2.yahoo.com>
References: <1386259047.2121.YahooMailNeo@web172705.mail.ir2.yahoo.com>
				 (sfid-20131205_165733_059424_F6F2D350) <1386259875.4182.15.camel@jlt4.sipsolutions.net>
			 <1386260074.45953.YahooMailNeo@web172706.mail.ir2.yahoo.com>
		 <1386260744.4182.18.camel@jlt4.sipsolutions.net>
		 <1386261738.73311.YahooMailNeo@web172703.mail.ir2.yahoo.com>
	 <1386265226.4182.20.camel@jlt4.sipsolutions.net>
	 <1386279479.16148.YahooMailNeo@web172701.mail.ir2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 21:37 +0000, Dani Camps wrote:
> Hi,
> 
> I tried with kernel 3.12 but I still get the same error. Just to
> clarify, if wmediumd would work properly you should see in the ping
> approximately half of the packets being dropped, because the
> configuration file has 0.5 drop probability for all rates. If you see
> that the ping proceeds normally is because the error happened and
> wmediumd de-registered.

Not sure I saw packet loss, but I made wmediumd print out statistics and
it was definitely seeing packets ...

johannes

