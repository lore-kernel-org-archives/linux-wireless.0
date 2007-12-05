Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:23050 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXLEKL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 05:11:59 -0500
Received: by py-out-1112.google.com with SMTP id u77so933016pyb
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2007 02:11:58 -0800 (PST)
Message-ID: <5b9417770712050211l6bff0376kcad1cc0f9677e605@mail.gmail.com> (sfid-20071205_101203_969615_BD367BDC)
Date: Wed, 5 Dec 2007 04:11:57 -0600
From: "John H." <mistamaila@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: b43 seemingly broken with Fedora (2.6.23.8-63.fc8) kernel
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200712051051.13667.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5b9417770712042039v2d7b2cc7l549d0bda2a57888e@mail.gmail.com>
	 <200712051051.13667.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

is there a bug in this kernel as well?
 2.6.23.1-49.fc8

I can stand right next to the router and        Bit Rate=1 Mb/s

sometimes it goes up a little, but barely.
It's a g router and this is a g wireless device.

I try to force bitrate change and it does nothing.  I really need it
at 54mb/s because of streaming local network media.

On Dec 5, 2007 3:51 AM, Michael Buesch <mb@bu3sch.de> wrote:
>
> On Wednesday 05 December 2007 05:39:02 John H. wrote:
> > I just upgraded to this kernel but i could never connect to an AP, it
> > just went on and on and timed out.  I had to go back to
> > 2.6.23.1-49.fc8
> >
> > did something big change?
> >
> >
>
> Yes, a big bug was introduced that breaks it on some devices.
>
> --
> Greetings Michael.
>
