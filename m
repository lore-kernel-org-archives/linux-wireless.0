Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22987 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYFYUMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 16:12:38 -0400
Subject: Re: [RFC] rtl8187: Realtek 8187B wireless support
	with	product	id0x8197/0x8189
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, hintak_leung@yahoo.co.uk,
	linux-wireless@vger.kernel.org
In-Reply-To: <48628D9A.5090502@lwfinger.net>
References: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net>
	 <1214415411.7901.25.camel@dv>  <4862840F.4030409@lwfinger.net>
	 <1214416662.9237.6.camel@dv>  <48628D9A.5090502@lwfinger.net>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 16:12:35 -0400
Message-Id: <1214424755.9990.11.camel@dv> (sfid-20080625_221242_458628_19F0DDCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-25 at 13:25 -0500, Larry Finger wrote:

> For the review process, I have split the patch into 5 parts. Each step 
> compiles, thus bisection will be preserved. With this change, the 
> largest of the pieces is a little under 15KiB. Is this small enough? 
> Further splitting would be a lot more difficult.

That's very impressive, actually.  Still the combined amount of the
changes makes me nervous.

> As to the quality of the patch, it barely works on my device. RX seems 
> to be OK except for the wireless statistics, but I can associate only 
> about 1 try in 10. Once I get that problem squared away, then I can 
> work on the timing. I really would like to get this into 
> wireless-testing ASAP.

I really appreciate your efforts.

> I don't have an 8187 device either, and will have to rely on someone 
> else for that part of the testing.

I've just bought a WiBee on eBay, which is said to be rtl8187 based.
Perhaps I'll be able to test it a week from now.

-- 
Regards,
Pavel Roskin
