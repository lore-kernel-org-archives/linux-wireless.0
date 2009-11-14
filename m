Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbZKNCI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 21:08:57 -0500
Subject: Re: Looking for the datasheet of zd1211rw...
From: Dan Williams <dcbw@redhat.com>
To: tomas zheng <tomaswlan.zheng@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Simon Raffeiner <sturmflut@lieberbiber.de>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1d91afb90911130620k2fd89166k9befcc1a643a4639@mail.gmail.com>
References: <1d91afb90911112231n54696c5fh950ba0102740d444@mail.gmail.com>
	 <45e8e6c40911112302s7c5c3e5cq496289512410ecba@mail.gmail.com>
	 <200911120847.44150.sturmflut@lieberbiber.de>
	 <1258051444.2347.124.camel@localhost.localdomain>
	 <1258051800.2347.127.camel@localhost.localdomain>
	 <1d91afb90911121758o6109145cl23894afda8bcbee2@mail.gmail.com>
	 <646765f40911121808m291a1b6amc13420e6fe384ddd@mail.gmail.com>
	 <1d91afb90911130620k2fd89166k9befcc1a643a4639@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 18:08:39 -0800
Message-Id: <1258164519.20338.12.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-13 at 22:20 +0800, tomas zheng wrote:
> Yes,NDISwrapper  is a good choice.

Well, not a *good* choice, but about the only choice you have.

Dan

> Thanks for you help.
> 
> 
> On Fri, Nov 13, 2009 at 10:08 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> > On Fri, Nov 13, 2009 at 12:58, tomas zheng <tomaswlan.zheng@gmail.com> wrote:
> >> Hi Dan and Guys,
> >>
> >> Thanks very much for your information.
> >> Very appreciated.
> >> I will try this today.
> >>
> >> But why I can not find the detail datasheet about 88W83xxxx on
> >> http://www.marvell.com and some googling?
> >> Anyone happened has it? Or , where should I go if I want it?
> >
> > Given Marvell's disinterest in Linux support for older 88w83xx
> > chipsets, I doubt you'll be able to get it for free, let alone under
> > NDA.
> >
> > Your best bet, if you're desperate for Linux support, is to port over
> > the old vendor driver to mac80211 as Dan pointed out.
> >
> > Otherwise, NDISwrapper might be your friend.
> >
> > Or you could do what I did when faced with a similar card, make my
> > other options (a rt2500pci based card) work.
> >
> > Thanks,
> >
> > --
> >
> > Julian Calaby
> >
> > Email: julian.calaby@gmail.com
> > .Plan: http://sites.google.com/site/juliancalaby/
> >

