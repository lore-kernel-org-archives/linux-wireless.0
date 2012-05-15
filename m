Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38915 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966939Ab2EOVcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 17:32:54 -0400
Date: Tue, 15 May 2012 17:16:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org
Subject: Re: [PATCH 0/8] ssb/bcma/bcm47xx: extend boardinfo and sprom
Message-ID: <20120515211605.GH24572@tuxdriver.com> (sfid-20120515_233258_512510_635C0367)
References: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 29, 2012 at 02:04:05AM +0200, Hauke Mehrtens wrote:
> This patch series fixes the boardinfo for ssb based devices by removing 
> board_rev from the struct, this should be fetched from sprom. In 
> addition a boardinfo struct was added to bcma.
> The pci sprom parsing code was extended for bcma to provide all 
> attributes needed by brcmsmac and that code was also copied to ssb.
> 
> This is based on wireless-testing/master.
> 
> Hauke Mehrtens (8):
>   ssb: remove rev from boardinfo
>   MIPS: bcm47xx: refactor fetching board data
>   bcma: add boardinfo struct
>   MIPS: bcm47xx: read baordrev without prefix from sprom
>   ssb/bcma: fill attribute alpha2 from sprom
>   ssb: fill board_rev attribute from sprom
>   bcma: read out some additional sprom attributes
>   bcma/ssb: parse new attributes from sprom

I'd still like to see an ACK from Ralf on the mips stuff?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
