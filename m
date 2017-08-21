Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:22777 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754035AbdHUVlR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 17:41:17 -0400
Date: Mon, 21 Aug 2017 14:34:30 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kvalo@codeaurora.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mt7601u: check memory allocation failure
Message-ID: <20170821143430.635e4b92@cakuba.netronome.com> (sfid-20170821_234119_912429_E20FA2E2)
In-Reply-To: <20170821205956.20859-1-christophe.jaillet@wanadoo.fr>
References: <20170821205956.20859-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Aug 2017 22:59:56 +0200, Christophe JAILLET wrote:
> Check memory allocation failure and return -ENOMEM in such a case, as
> already done a few lines below
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks!
