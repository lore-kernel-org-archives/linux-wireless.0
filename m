Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:32298 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753048AbeCaGRP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Mar 2018 02:17:15 -0400
Date: Fri, 30 Mar 2018 23:17:05 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: phy: mark expected switch fall-through
Message-ID: <20180330231705.3d12f2a5@cakuba.netronome.com> (sfid-20180331_081745_104454_2CA51750)
In-Reply-To: <20180330211223.GA22497@embeddedgus>
References: <20180330211223.GA22497@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 30 Mar 2018 16:12:23 -0500, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
