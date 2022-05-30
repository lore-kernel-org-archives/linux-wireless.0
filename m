Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D5CC433F5
	for <linux-wireless@archiver.kernel.org>; Mon, 30 May 2022 16:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbiE3QWo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 30 May 2022 12:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiE3QWo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 May 2022 12:22:44 -0400
Received: from ns.iliad.fr (ns.iliad.fr [212.27.33.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A964D3E;
        Mon, 30 May 2022 09:22:41 -0700 (PDT)
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 14274202C7;
        Mon, 30 May 2022 18:22:40 +0200 (CEST)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 0F16120260;
        Mon, 30 May 2022 18:22:40 +0200 (CEST)
Message-ID: <7f93d9d5fcbce1ae8d2e87069c27bf86a610303b.camel@freebox.fr>
Subject: Re: [PATCH v7 4/9] ath11k: Add register access logic for WCN6750
From:   Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org, mka@chromium.org
Date:   Mon, 30 May 2022 18:22:39 +0200
In-Reply-To: <871qwbouzq.fsf@kernel.org>
References: <20220429170502.20080-1-quic_mpubbise@quicinc.com>
         <20220429170502.20080-5-quic_mpubbise@quicinc.com>
         <bd6d97a4cc6665d0ee632444f75e3480160387ec.camel@freebox.fr>
         <c57e8791-b6ce-0752-52ca-a1cb938187d7@quicinc.com>
         <c1c3472427080716c69ad99ebe5d1954db44f03f.camel@freebox.fr>
         <871qwbouzq.fsf@kernel.org>
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Mon May 30 18:22:40 2022 +0200 (CEST)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On Mon, 2022-05-30 at 19:17 +0300, Kalle Valo wrote:

> Looks good to me. Can you submit that as a proper patch?

I'd prefer that patch to come from someone with actual knowledge of the
hardware, I basically did a blind revert

-- 
Maxime



