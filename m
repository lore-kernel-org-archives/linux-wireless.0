Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:20898 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754102AbdHUWZX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 18:25:23 -0400
Date: Mon, 21 Aug 2017 15:25:15 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kvalo@codeaurora.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] mt7601u: check memory allocation failure
Message-ID: <20170821152515.717a4681@cakuba.netronome.com> (sfid-20170822_002540_377342_1B4679DE)
In-Reply-To: <20170821220617.21513-1-christophe.jaillet@wanadoo.fr>
References: <20170821220617.21513-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Aug 2017 00:06:17 +0200, Christophe JAILLET wrote:
> Check memory allocation failure and return -ENOMEM in such a case, as
> already done a few lines below.
> 
> As 'dev->tx_q' can be NULL, we also need to check for that in
> 'mt7601u_free_tx()', and return early.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
