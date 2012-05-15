Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([78.24.191.182]:42131 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944Ab2EOV4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 17:56:07 -0400
Received: from localhost.localdomain ([127.0.0.1]:48398 "EHLO h5.dl5rb.org.uk"
        rhost-flags-OK-OK-OK-FAIL) by eddie.linux-mips.org with ESMTP
        id S1903706Ab2EOV4E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2012 23:56:04 +0200
Date: Tue, 15 May 2012 23:55:51 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com, m@bues.ch
Subject: Re: [PATCH 0/8] ssb/bcma/bcm47xx: extend boardinfo and sprom
Message-ID: <20120515215551.GA16397@linux-mips.org> (sfid-20120515_235613_486536_D7760338)
References: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
 <20120515211605.GH24572@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120515211605.GH24572@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2012 at 05:16:05PM -0400, John W. Linville wrote:

> On Sun, Apr 29, 2012 at 02:04:05AM +0200, Hauke Mehrtens wrote:
> > This patch series fixes the boardinfo for ssb based devices by removing 
> > board_rev from the struct, this should be fetched from sprom. In 
> > addition a boardinfo struct was added to bcma.
> > The pci sprom parsing code was extended for bcma to provide all 
> > attributes needed by brcmsmac and that code was also copied to ssb.
> > 
> > This is based on wireless-testing/master.
> > 
> > Hauke Mehrtens (8):
> >   ssb: remove rev from boardinfo
> >   MIPS: bcm47xx: refactor fetching board data
> >   bcma: add boardinfo struct
> >   MIPS: bcm47xx: read baordrev without prefix from sprom
> >   ssb/bcma: fill attribute alpha2 from sprom
> >   ssb: fill board_rev attribute from sprom
> >   bcma: read out some additional sprom attributes
> >   bcma/ssb: parse new attributes from sprom
> 
> I'd still like to see an ACK from Ralf on the mips stuff?

Sorry, I'm awfully backloged.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
