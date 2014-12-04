Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbaLDI1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 03:27:09 -0500
Date: Thu, 4 Dec 2014 09:23:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Parth Sane <laerdevstudios@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	driverdev-devel@linuxdriverproject.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Ralink 6570 / Mediatek MT7601STA (was Re: Addition of a wifi
 kernel module to the linux source tree)
Message-ID: <20141204082348.GA1989@redhat.com> (sfid-20141204_092713_856211_AEB3E93A)
References: <CAD-4tLW3cvGrw3MYiLQni7OMJYGa=QJbrk_q9=9P2QuBb1EVFg@mail.gmail.com>
 <CA+55aFw6zo4rTsEEX5uQe+8zeNR87JzmM8T=wYW7jvrHZPjB8A@mail.gmail.com>
 <20141129191601.GA1234@kroah.com>
 <CAD-4tLXYVtKJMWYW6cQ9aCL6rusUx3YpWSHys4xcTRN_dJ+kOA@mail.gmail.com>
 <20141130184615.GA3122@kroah.com>
 <CAD-4tLU-3otYOTO98s359z80SSbTJbiSstAYijiU__ekOPJkOA@mail.gmail.com>
 <20141204012407.GA31191@kroah.com>
 <CAD-4tLVrOqiUX2V9_VWMBbnFT-qEsO=zQF4qejd_N2H=scb4aw@mail.gmail.com>
 <20141204043945.GA22144@kroah.com>
 <CAGRGNgXiAAcFoUJyJiC2=yi7LGAU-=6L=NZpJxNj3V4E74RxCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgXiAAcFoUJyJiC2=yi7LGAU-=6L=NZpJxNj3V4E74RxCw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2014 at 03:52:52PM +1100, Julian Calaby wrote:
> On Thu, Dec 4, 2014 at 3:39 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Dec 04, 2014 at 07:07:58AM +0530, Parth Sane wrote:
> >> Hi,
> >> I'd say I'm midway through with c programming(part of my computer
> >> engineering degree course) and know a decent amount of git. So yes I'm
> >> comfortable writing code.
> >
> > Ok great, let's see if it's just a matter of some changes to the
> > existing kernel driver before we decide to add the whole huge tarball
> > to the staging tree as fixing it up will be a lot of work.
> 
> I believe some people (CC'd) may have been working on / had an
> interest in writing such a driver. I'm not sure what the status of
> that effort is though.

Right. Felix is working on new linux friendly driver for new Mediatek
chips.

Stanislaw
