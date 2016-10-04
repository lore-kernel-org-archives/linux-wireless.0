Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51465 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753192AbcJDPqv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 11:46:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Vittorio Gambaletta \(VittGam\)" <linux-wireless@vittgam.net>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <ath9k-devel@venema.h4ckr.net>, <stable@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Move generic entries below specific ones in ath_pci_id_table.
References: <ath9k-patch-20161003@vittgam.net>
Date: Tue, 04 Oct 2016 18:46:44 +0300
In-Reply-To: <ath9k-patch-20161003@vittgam.net> (Vittorio Gambaletta's message
        of "Mon, 3 Oct 2016 12:00:56 +0200")
Message-ID: <87k2dop15n.fsf@kamboji.qca.qualcomm.com> (sfid-20161004_174656_852736_5E591DDA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net> writes:

> If generic entries are positioned above specific ones, then the
> former will be matched first and used instead of the latter.
>
> Cc: <linux-wireless@vger.kernel.org>
> Cc: <ath9k-devel@qca.qualcomm.com>
> Cc: <ath9k-devel@lists.ath9k.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>

Why? What kind of bug you are fixing? You are not really describing the
problem you are trying fix.

And your email headers look weird:

To:     <kvalo@codeaurora.org>
Cc:     <linux-wireless@vger.kernel.org>
Cc:     <ath9k-devel@qca.qualcomm.com>
Cc:     <ath9k-devel@venema.h4ckr.net>
Cc:     <stable@vger.kernel.org>
Date:   Mon, 3 Oct 2016 12:00:56 +0200

What software are you using to send this? Only one CC header is valid
according to the spec (thanks to Luca for checking) even though mailers
seem to handle multiple CC headers. But for example my patchwork script
fails with this and uses only the first CC header.

-- 
Kalle Valo
