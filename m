Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:41733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440AbXFUQgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 12:36:08 -0400
Received: by ug-out-1314.google.com with SMTP id j3so614272ugf
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2007 09:36:07 -0700 (PDT)
Message-ID: <467AA8D2.5050305@googlemail.com>
Date: Thu, 21 Jun 2007 18:35:30 +0200
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Lameter <clameter@sgi.com>,
	Dave Airlie <airlied@linux.ie>,
	Andrea Righi <righiandr@users.sourceforge.net>,
	Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
	Marc Pignat <marc.pignat@hevs.ch>,
	Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <samuel@sortiz.org>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	Samuel Ortiz <samuel@sortiz.org>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Chad Tindel <ctindel@users.sourceforge.net>,
	Olaf Hering <olaf@aepfle.de>
Subject: Re: [2/2] 2.6.22-rc5: known regressions with patches v2
References: <467AA7E3.3030404@googlemail.com>
In-Reply-To: <467AA7E3.3030404@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Here is a list of some known regressions in 2.6.22-rc5
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

(BTW. There is a new category called "Will be fixed in 2.6.23")



Memory management

Subject    : bug in i386 MTRR initialization
References : http://lkml.org/lkml/2007/5/19/93
Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
Status     : patch available



MMC

Subject    : Oops in a driver while using SLUB as a SLAB allocator
References : http://lkml.org/lkml/2007/6/21/69
Submitter  : Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Handled-By : Marc Pignat <marc.pignat@hevs.ch>
Patch      : http://lkml.org/lkml/2007/6/21/140
Status     : patch available



Networking

Subject    : ERROR: "__ucmpdi2" [drivers/net/s2io.ko] undefined!
References : http://lkml.org/lkml/2007/6/19/310
Submitter  : Olaf Hering <olaf@aepfle.de>
Patch      : http://lkml.org/lkml/2007/6/19/382
Status     : patch was suggested

Subject    : no irda0 interface (2.6.21 was OK), smsc does not find chip
References : http://lkml.org/lkml/2007/6/3/16
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Handled-By : Samuel Ortiz <samuel@sortiz.org>
             Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch      : http://lkml.org/lkml/2007/6/7/237
Status     : patch was suggested



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
