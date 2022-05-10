Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA10BC433EF
	for <linux-wireless@archiver.kernel.org>; Tue, 10 May 2022 16:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347440AbiEJQgc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 May 2022 12:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347504AbiEJQgS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 May 2022 12:36:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E49D80A0
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2022 09:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4985617FE
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2022 16:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E70C385A6;
        Tue, 10 May 2022 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652200340;
        bh=cB8wY2dxDEiVsAOmFZdvZ3VSskFcuAZTQ783Pq/UNMA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VUkhaSE7EEA9dxmumtqCRg2d+MdrhJs4OW7KsiDZNNwWGv9EYJbrnxLgXK8GbiS53
         mrWtGE8YiFau6lG1mUtTq8bWaIBOA9RaoUluqwavaQppmhWBTQCjelpenl1Rp9PE7y
         62O2hZ+pjxvLhXd4J0DXBOc2ufeazhIgbt7snFcIjoND10+pyraTJQylCMUQtg1fWU
         F21YWqRrjczBQaPfJq19iEtDfYIJ4IK5CWWM5HXTfujWTAVp0E97kZi3SvJAFP8FbM
         wQuwYAeIe7fvq7QtXzlpSt+oQbTrS6qfrxaQKjaVJ9wH6FXoBDIGuQYWrKFw+hT9Pu
         cANE+XVIdjxDQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/3] ath11k: Implement remain-on-channel support
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220506013614.1580274-2-quic_bqiang@quicinc.com>
References: <20220506013614.1580274-2-quic_bqiang@quicinc.com>
To:     Baochen Qiang <quic_bqiang@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165220033736.6768.15987783390890770630.kvalo@kernel.org>
Date:   Tue, 10 May 2022 16:32:19 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Baochen Qiang <quic_bqiang@quicinc.com> wrote:

> Add remain on channel support, it is needed in several
> scenarios such as Passpoint etc.
> 
> Currently this is supported by QCA6390, WCN6855, IPQ8074,
> IPQ6018 and QCN9074.
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
> 
> Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

3 patches applied to ath-next branch of ath.git, thanks.

3a5627b94222 ath11k: Implement remain-on-channel support
355333a21754 ath11k: Don't check arvif->is_started before sending management frames
1d7f514577f0 ath11k: Designating channel frequency when sending management frames

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220506013614.1580274-2-quic_bqiang@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

