Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:40117 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328AbZKDWb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:31:56 -0500
Received: by ewy3 with SMTP id 3so3674474ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 14:32:01 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Subject: Re: compat-wireless and minstrel
Date: Wed, 4 Nov 2009 23:31:55 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Adam Wozniak <awozniak@irobot.com>,
	linux-wireless@vger.kernel.org
References: <4AF0D54D.4090303@irobot.com> <200911042318.13528.chunkeey@googlemail.com> <20091104222007.GB2599@bombadil.infradead.org>
In-Reply-To: <20091104222007.GB2599@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911042331.56052.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 23:20:07 Luis R. Rodriguez wrote:
> On Wed, Nov 04, 2009 at 11:18:13PM +0100, Christian Lamparter wrote:
> > On Wednesday 04 November 2009 22:50:46 Luis R. Rodriguez wrote:
> > > On Wed, Nov 4, 2009 at 1:46 PM, Adam Wozniak <awozniak@irobot.com> wrote:
> > > >
> > > > $ ls -la /lib/firmware/ar9170*
> > > > -rw-r--r-- 1 root root 83968 2009-10-17 15:55 /lib/firmware/ar9170-1.fw
> > > > -rw-r--r-- 1 root root  3508 2009-10-17 15:55 /lib/firmware/ar9170-2.fw
> > > > -rw-r--r-- 1 root root 15960 2009-10-17 15:55 /lib/firmware/ar9170.fw
> > > >
> > > > It is unclear to me which are actually used.
> > > 
> > > By default the ar9170.fw is tried first, if that fails then the others
> > > are tried. The 2-stage firmware will not be tried if your device
> > > cannot handle it but right now only the AVM Fritz devices can't handle
> > > the 2-stage firmware.
> > > 
> > > Christian should we just remove 2-stage fw support?
> > 
> > I've moved the two-stage fw into the legacy section some time ago :)
> > Maybe a add printk?
> 
> Oh sorry didn't notice, I meant complete removal of its support on the
> driver though :)
Oh, I've no problem removing two-stage fw support.
But then, I don't know much about usability :-D and I've enough of 
people banging their heads against each other.

Regards,
	Chr
