Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12312 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbZIAQPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 12:15:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 09:15:14 -0700
Date: Tue, 1 Sep 2009 09:15:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"aquilaver@yahoo.com" <aquilaver@yahoo.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	Kai Engert <kengert@redhat.com>,
	Jean Tourrilhes <jt@hpl.hp.com>,
	Tim de Waal <tim.dewaal@yahoo.com>,
	Roy Marples <uberlord@gentoo.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Christian Lamparter <chunkeey@web.de>,
	=?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] wireless: mark prism54 as deprecated and mark for
 removal
Message-ID: <20090901161513.GD8261@mosca>
References: <1251819116-10004-1-git-send-email-lrodriguez@atheros.com>
 <4A9D469B.9060005@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A9D469B.9060005@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 09:06:51AM -0700, Larry Finger wrote:
> Luis R. Rodriguez wrote:
> > The preferred modules is p54 which also supports FullMAC
> 
> This needs to be "modules are" or "module is". I know p54 is really a
> family, but I think you specifically mean p54pci here.

Will fix.

> > PCI / Cardbus devices. We schedule removal for 2.6.34. Reason
> > to remove this is no one really is testing prism54 anymore,
> > and while it works p54 provides support for the same hardware.
>                      ===
> p54pci?

That would make it clearer, yes thanks.

> > It should be noted I have been told some FullMAC devices may not
> > have worked with the SoftMAC driver but to date we have yet to
> > recieve a single bug report regarding this. If there are users
>   =======
> receive

ack

> > out there please let us know!
>   =========
> 
> Those words can be removed.
> 
> Otherwise, ACK.

Thanks for the review, will resend with the changes.

  Luis
