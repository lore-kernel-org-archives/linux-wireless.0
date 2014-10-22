Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53354 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026AbaJVMTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 08:19:31 -0400
Received: by mail-ie0-f173.google.com with SMTP id tr6so1293502ieb.32
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 05:19:31 -0700 (PDT)
Date: Wed, 22 Oct 2014 08:18:24 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
	Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH v2 11/13] ath5k: revert AHB bus support removing
Message-ID: <20141022121824.GA19113@localhost> (sfid-20141022_141935_422732_258F1590)
References: <1413932631-12866-1-git-send-email-ryazanov.s.a@gmail.com>
 <1413932631-12866-12-git-send-email-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413932631-12866-12-git-send-email-ryazanov.s.a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2014 at 03:03:49AM +0400, Sergey Ryazanov wrote:
> This reverts commit 093ec3c5337434f40d77c1af06c139da3e5ba6dc.
> 
> AHB bus code has been removed, since we did not have support Atheros
> AR231x SoC, required for building the AHB version of ath5k. Now that
> support WiSoC chips added we can restore functionality back.
> 
> Singed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
  ^^^^^^

Please keep the patches away from the stove! (SCNR)

-- 
Bob Copeland %% www.bobcopeland.com
