Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37387 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbXLIK7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 05:59:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John H." <mistamaila@gmail.com>
Subject: Re: b43 continues to have issue with APs at times
Date: Sun, 9 Dec 2007 11:57:21 +0100
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <5b9417770712081222y4f0ab1va51910faf16fb068@mail.gmail.com> <200712082135.11685.mb@bu3sch.de> <5b9417770712090001t631bb650l531fbb7efb1cc80c@mail.gmail.com>
In-Reply-To: <5b9417770712090001t631bb650l531fbb7efb1cc80c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712091157.22000.mb@bu3sch.de> (sfid-20071209_105925_784002_884FDA9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 December 2007 09:01:26 John H. wrote:
> no, i stopped using ndiswrapper a while back because I wanted to use
> b43, but I did not have this issue then.

But ndiswrapper doesn't use mac80211, right?
Do you see this issue with other _mac80211_ drivers?

> On Dec 8, 2007 2:35 PM, Michael Buesch <mb@bu3sch.de> wrote:
> >
> > On Saturday 08 December 2007 21:22:37 John H. wrote:
> > > I have this problem at two different locations with two different
> > > access points.  2.6.23.1 kernel, and sometimes until I actually power
> > > down the AP and restart it, wpa_supplicant and such just times out on
> > > the AP.
> > >
> > > Any ideas?
> > >
> > >
> >
> > I think that's rather a mac80211 or supplicant issue.
> > I think roaming should handle this.
> > Do you see this with other drivers, too?
> >
> > --
> > Greetings Michael.
> >
> 
> 



-- 
Greetings Michael.
