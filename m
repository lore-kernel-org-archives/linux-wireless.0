Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32223 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbYFYR5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 13:57:44 -0400
Subject: Re: [RFC] rtl8187: Realtek 8187B wireless support with
	product	id0x8197/0x8189
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, hintak_leung@yahoo.co.uk,
	linux-wireless@vger.kernel.org
In-Reply-To: <4862840F.4030409@lwfinger.net>
References: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net>
	 <1214415411.7901.25.camel@dv>  <4862840F.4030409@lwfinger.net>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 13:57:42 -0400
Message-Id: <1214416662.9237.6.camel@dv> (sfid-20080625_195749_738511_0E5AA256)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-25 at 12:44 -0500, Larry Finger wrote:

> I realize that now. I'll fix that. Is it OK that there is a 
> "Signed-off-by" for you?

As far as the copyright goes, yes.  But I was mostly forward porting and
removing unrelated parts, so there is very little code written by me in
that patch.

I'm not sure I can stand behind that patch quality-wise.   It's 40k of
intrusive changes that I could not even test on an old rtl8187.  If I
had more time and a original rtl8187 device, I would try to split more
parts or restructure the code first.

Also, the startup time (ifconfig up) is over 20 seconds, which is
absolutely unacceptable.  Either some delays are over-conservative, or
we are doing something wrong.

-- 
Regards,
Pavel Roskin
