Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18316 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYFBGl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 02:41:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH, take 2] libertas: unify various CF-related defines
Date: Mon, 2 Jun 2008 08:41:21 +0200
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
References: <200805261250.50363.hs4233@mail.mn-solutions.de> <20080530154113.GB9490@tuxdriver.com>
In-Reply-To: <20080530154113.GB9490@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806020841.21481.hs4233@mail.mn-solutions.de> (sfid-20080602_084132_081984_AED2F000)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 30 May 2008 17:41:13 John W. Linville wrote:
> On Mon, May 26, 2008 at 12:50:50PM +0200, Holger Schurig wrote:
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>
> git says:
>
> Applying libertas: don't spin_unlock_irq() twice
> Applying libertas: speeds up downloading of CF firmware
> Applying libertas: use lbs_pr_XX instead of printk
> Applying libertas: before sleeping, check for a command result
> Applying libertas: unify various CF-related defines
> error: patch failed: drivers/net/wireless/libertas/if_cs.c:221
> error: drivers/net/wireless/libertas/if_cs.c: patch does not
> apply

It should applied after "Re: [PATCH, take 3] libertas: fix 
compact flash interrupt handling".
