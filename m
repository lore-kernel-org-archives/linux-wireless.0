Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41618 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698AbYGRS3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:29:36 -0400
Date: Fri, 18 Jul 2008 15:29:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v2] ath5k: don't enable MSI, we cannot handle it yet
Message-ID: <20080718182930.GA30077@khazad-dum.debian.net> (sfid-20080718_202940_023832_71D88B60)
References: <20080718162855.22182.97573.stgit@dv.roinet.com> <1216399487.18320.16.camel@dv> <200807181849.25320.mb@bu3sch.de> <1216400219.18320.26.camel@dv> <40f31dec0807181057y65738617m8bcfa9c6c9f71671@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0807181057y65738617m8bcfa9c6c9f71671@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 Jul 2008, Nick Kossifidis wrote:
> 2008/7/18 Pavel Roskin <proski@gnu.org>:
> > MSI is a nice thing, but we cannot enable it without changing the
> > interrupt handler.  If we do it, we break MSI capable hardware,
> > specifically AR5006 chipset.
> >
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
[...]
> Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Cc: stable@kernel.org

So that they will pick it up automatically when it hits mainline, and it
also serves as an in-band documentation that it is something that needs to
go/went to -stable.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
