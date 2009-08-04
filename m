Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44895 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZHDQQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 12:16:06 -0400
Date: Tue, 4 Aug 2009 12:05:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: gregor kowski <gregor.kowski@gmail.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] remove wrong probe_resp_plcp write
Message-ID: <20090804160558.GC4995@tuxdriver.com>
References: <83a869cd0907311335h3065547aqc736573a663b6d42@mail.gmail.com> <200907312238.15705.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200907312238.15705.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 10:38:14PM +0200, Michael Buesch wrote:
> On Friday 31 July 2009 22:35:49 gregor kowski wrote:
> > The tkip hw support uncovered a bug in b43_write_probe_resp_template : it is
> > writing at the wrong shm offset, it is in the B43_SHM_SH_TKIPTSCTTAK zone. This
> > patch comments these writes.
> > 
> > Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

  CC [M]  drivers/net/wireless/b43/main.o
drivers/net/wireless/b43/main.c:1432: warning: ‘b43_write_probe_resp_plcp’ defined but not used

Comment it out too?  Or are you going to fix the block that has been
commented-out here?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
