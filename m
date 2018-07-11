Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726490AbeGKJaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 05:30:10 -0400
Date: Wed, 11 Jul 2018 11:26:44 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Colin King <colin.king@canonical.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: remove several redundant variables
Message-ID: <20180711092644.GA2114@redhat.com> (sfid-20180711_112706_591201_FFA6B0B4)
References: <20180711074253.4192-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180711074253.4192-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2018 at 08:42:53AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variables id, unicast, write, conf, a_band, accum_tx and ucode are
> assigned a value but it is never read, hence they are redundant and
> can be removed.
> 
> Cleans up clang warnings:
> warning: variable 'id' set but not used [-Wunused-but-set-variable]
> warning: variable 'unicast' set but not used [-Wunused-but-set-variable]
> warning: variable 'write' set but not used [-Wunused-but-set-variable]
> warning: variable 'conf' set but not used [-Wunused-but-set-variable]
> warning: variable 'a_band' set but not used [-Wunused-but-set-variable]
> warning: variable 'tx' set but not used [-Wunused-but-set-variable]
> warning: variable 'accum_tx' set but not used [-Wunused-but-set-variable]
> warning: variable 'ucode' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
