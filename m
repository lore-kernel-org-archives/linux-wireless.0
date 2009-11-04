Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbZKDWUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:20:02 -0500
Date: Wed, 4 Nov 2009 17:20:07 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Adam Wozniak <awozniak@irobot.com>,
	linux-wireless@vger.kernel.org
Subject: Re: compat-wireless and minstrel
Message-ID: <20091104222007.GB2599@bombadil.infradead.org>
References: <4AF0D54D.4090303@irobot.com> <4AF1F653.4000905@irobot.com> <43e72e890911041350i75108dc3g454ab8577d8abacd@mail.gmail.com> <200911042318.13528.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200911042318.13528.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 11:18:13PM +0100, Christian Lamparter wrote:
> On Wednesday 04 November 2009 22:50:46 Luis R. Rodriguez wrote:
> > On Wed, Nov 4, 2009 at 1:46 PM, Adam Wozniak <awozniak@irobot.com> wrote:
> > >
> > > $ ls -la /lib/firmware/ar9170*
> > > -rw-r--r-- 1 root root 83968 2009-10-17 15:55 /lib/firmware/ar9170-1.fw
> > > -rw-r--r-- 1 root root  3508 2009-10-17 15:55 /lib/firmware/ar9170-2.fw
> > > -rw-r--r-- 1 root root 15960 2009-10-17 15:55 /lib/firmware/ar9170.fw
> > >
> > > It is unclear to me which are actually used.
> > 
> > By default the ar9170.fw is tried first, if that fails then the others
> > are tried. The 2-stage firmware will not be tried if your device
> > cannot handle it but right now only the AVM Fritz devices can't handle
> > the 2-stage firmware.
> > 
> > Christian should we just remove 2-stage fw support?
> 
> I've moved the two-stage fw into the legacy section some time ago :)
> Maybe a add printk?

Oh sorry didn't notice, I meant complete removal of its support on the
driver though :)

  Luis
