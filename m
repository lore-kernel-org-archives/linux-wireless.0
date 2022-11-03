Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A460C4332F
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Nov 2022 06:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiKCGHH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Nov 2022 02:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiKCGHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2022 02:07:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B575B193C4;
        Wed,  2 Nov 2022 23:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67689B82623;
        Thu,  3 Nov 2022 06:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33235C433D6;
        Thu,  3 Nov 2022 06:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667455621;
        bh=LPrafYX9hEsEzaF5fMXuFCwDsoy3H56OcRw/rH9JSXM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SFHvRsWL6B4CnT0K6atnhiGEFmoh72vRzlJkk0ycPcCDJUWg8XaCq0gyic1c37aST
         53sfpIR/srKbe851c5z2J/rGT0AttdFSo2eSLVFQjaB+kEdab9BN/SqDBdjjmi5WXG
         eH/Ysi5IJbAJssr1GQoxFSPmIECgKvCKQzhqEnswoWaclVGpAdh7fsmwBThpdJ1t1x
         pkVCeiEqlBsCZ5PcJmKzHcdTe5RSpCk4jcYPhCTS9P+cq/Bt3oyb526N8pZD4lduqU
         axBDLByaWX2JZgK2XvDdrxaFNDWfN7D5vl9sDU59c0nZWeRY0/Dpfml5GGhceFNrGj
         XaDjDuOuT+LCA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: ath10k: Make QMI message rules const
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220915002612.13394-1-quic_jjohnson@quicinc.com>
References: <20220915002612.13394-1-quic_jjohnson@quicinc.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166745561698.21329.18124838626287583830.kvalo@kernel.org>
Date:   Thu,  3 Nov 2022 06:06:59 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jeff Johnson <quic_jjohnson@quicinc.com> wrote:

> Commit ff6d365898d4 ("soc: qcom: qmi: use const for struct
> qmi_elem_info") allows QMI message encoding/decoding rules
> to be const, so do that for ath10k.
> 
> Compile tested only.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

11e1fcf2b494 wifi: ath10k: Make QMI message rules const

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220915002612.13394-1-quic_jjohnson@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

