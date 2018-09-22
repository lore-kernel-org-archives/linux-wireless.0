Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42078 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbeIVSFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 14:05:23 -0400
Subject: Re: [PATCH] mt76: fix return value of mt76x02_wait_for_mac
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <1536226714-17201-1-git-send-email-sgruszka@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <b2ba069e-5ba8-17bd-e51c-7edbb1209689@nbd.name> (sfid-20180922_141247_973832_3DFDE8AF)
Date: Sat, 22 Sep 2018 14:11:53 +0200
MIME-Version: 1.0
In-Reply-To: <1536226714-17201-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-06 11:38, Stanislaw Gruszka wrote:
> We need to return bool value in mt76x02_wait_for_mac.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 2735a6dd7df3 ("mt76: unify wait_for_mac")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Merged, thanks.

- Felix
