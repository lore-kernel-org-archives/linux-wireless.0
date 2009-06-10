Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57359 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZFJHT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 03:19:27 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090610024437.GF593@khazad-dum.debian.net>
References: <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk>
	 <1243932109.3192.73.camel@localhost.localdomain>
	 <20090603041030.GB10464@khazad-dum.debian.net>
	 <1244034216.22679.22.camel@localhost.localdomain>
	 <20090603214040.GD22809@khazad-dum.debian.net>
	 <1244089486.4145.33.camel@localhost.localdomain>
	 <20090607135456.GE3340@khazad-dum.debian.net>
	 <1244388961.23850.93.camel@localhost.localdomain>
	 <20090610024437.GF593@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 09:19:24 +0200
Message-Id: <1244618364.3068.34.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > > You can remove the EPO functionality and add a "switch all radios off"
> > > and "switch all radios on" accell commands.  But that's all you can do
> > > if you depend on userspace.  It will -not- be EPO.
> > > 
> > > You can have EPO in the kernel, and have userspace command the kernel to
> > > enter and exit EPO state.
> > 
> > I fully disagree with you here and your concept of EPO and how it is
> > suppose to work is fully flawed. EPO is a policy and if you define it as
> 
> Just rename it to something else.
> 
> Whether the current code can achieve what EPO is suposed to be is beside
> the point.  Just rename that functionality to something else, as the
> direction you want to go is clearly NOT one suitable for something named
> "EPO".

I don't care about the name. You can name it whatever you want. The
point here is that it is a policy and so we trigger it from userspace.
And we are finally fully capable of doing so with almost all subsystems
from a simple daemon. Only exception is most external 3G (as mentioned
in my other email) and my WiMAX is behaving a little bit quirky, but I
am looking into that.

Regards

Marcel


