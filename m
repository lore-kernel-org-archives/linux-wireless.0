Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2A0RFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 12:05:55 -0500
Date: Fri, 27 Jan 2012 11:05:49 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
Message-ID: <20120127170549.GB2251@ubuntu-macmini> (sfid-20120127_180601_275686_3AEEA715)
References: <20111214162333.GB19410@thinkpad-t410>
 <4EE8D150.8090100@lwfinger.net>
 <20111214164902.GD19410@thinkpad-t410>
 <4EE8D5A1.7040600@lwfinger.net>
 <20111214171234.GE19410@thinkpad-t410>
 <4EE8E035.90501@lwfinger.net>
 <20111214175804.GG19410@thinkpad-t410>
 <20120126213344.GC14465@ubuntu-macmini>
 <4F21E6CF.5040006@lwfinger.net>
 <20120127030623.GA26774@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120127030623.GA26774@ubuntu-macmini>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 09:06:23PM -0600, Seth Forshee wrote:
> On Thu, Jan 26, 2012 at 05:50:39PM -0600, Larry Finger wrote:
> > On 01/26/2012 03:33 PM, Seth Forshee wrote:
> > >Sorry for the long silence on this, I was busy with some other things.
> > >But I've been playing with it again this week and uncovered some new
> > >information regarding the failures.
> > >
> > >I noticed the other day that the rtl8188ce was no longer having trouble
> > >associating with this AP. After playing around in the router settings I
> > >discovered that it works fine so long as the router isn't on channel 1.
> > >So then I configured my other router to use channel 1, and then I
> > >started seeing problems with that router as well.
> > >
> > >I also tried the rtl8192ce driver from Realtek's website, and I'm having
> > >better luck with that driver.
> > 
> > Seth,
> > 
> > Are those AP's 802.11n devices that allow HT features on channel 1?
> > I do not know if we support that or not. On my 802.11n device, it
> > automatically switches to channel 3 when I enable HT, and that
> > works.
> > 
> > I can connect to an 802.11g AP on channel 1 with no trouble.
> 
> Whether or not HT is enabled makes no difference. One is an older
> 802.11g router, and on the other I see the same problems with or without
> HT enabled.

I decided to remove the card from the netbook and test it in another
machine, and it worked flawlessly. A different card in the netbook works
fine as well.

But then after reinstalling the rtl8188ce in the netbook I'm not seeing
any problems associating. None at all. So perhaps the issue was
mechanical in nature.

I'll keep testing it for a while to see if the problems resurface, but
for now everything seems fine. Thanks for your help.

Seth
