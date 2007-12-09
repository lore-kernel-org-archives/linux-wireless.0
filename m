Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:22099 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXLIIB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 03:01:27 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2567392wah
        for <linux-wireless@vger.kernel.org>; Sun, 09 Dec 2007 00:01:27 -0800 (PST)
Message-ID: <5b9417770712090001t631bb650l531fbb7efb1cc80c@mail.gmail.com> (sfid-20071209_080132_594754_2D7F4181)
Date: Sun, 9 Dec 2007 02:01:26 -0600
From: "John H." <mistamaila@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: b43 continues to have issue with APs at times
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200712082135.11685.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5b9417770712081222y4f0ab1va51910faf16fb068@mail.gmail.com>
	 <200712082135.11685.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

no, i stopped using ndiswrapper a while back because I wanted to use
b43, but I did not have this issue then.

On Dec 8, 2007 2:35 PM, Michael Buesch <mb@bu3sch.de> wrote:
>
> On Saturday 08 December 2007 21:22:37 John H. wrote:
> > I have this problem at two different locations with two different
> > access points.  2.6.23.1 kernel, and sometimes until I actually power
> > down the AP and restart it, wpa_supplicant and such just times out on
> > the AP.
> >
> > Any ideas?
> >
> >
>
> I think that's rather a mac80211 or supplicant issue.
> I think roaming should handle this.
> Do you see this with other drivers, too?
>
> --
> Greetings Michael.
>
