Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22C0C6FA9D
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Mar 2023 14:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCAOKl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Mar 2023 09:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjCAOKj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2023 09:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B178A19A1
        for <linux-wireless@vger.kernel.org>; Wed,  1 Mar 2023 06:10:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D7CFB80EFA
        for <linux-wireless@vger.kernel.org>; Wed,  1 Mar 2023 14:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A34C433EF;
        Wed,  1 Mar 2023 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677679836;
        bh=95EbawGRJarKXNkGR0ibN/sMlYLi0RfOACr+KSxrnII=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=W5KzF3D4Thu27h5oOem2tHY+4u2WMkFqwWuaspa5STMkDwjNvkrFJ0djCuR3G91y3
         TbdXkHsV1a17ZY8eF/fKgp9hdyd37eB/3JR9QR0WMmFJjFeydQMgnrieIrDIn0RSTJ
         R38ss6PXeckNNhQf436b234nf6wp25RfZQ+GUwzJVv2RSj4oUTdR2IIa2eD51F3Cpb
         /lZ8q5b8fIWMHY14TyM1YMmgzVe7Dk9CerWLq1VDMoIg2ZpoMuxj6h0TndesVIjwVK
         K0V8Co7WMOcZZCrVmhMZp8DL7RTDUXffYo2JFpkzrwCbg7AmLFCn83VDlUSCmkYNTl
         jo/C08qy0Mt1Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: Add tx ack signal support for mgmt packets
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221219053844.4084486-1-quic_mkenna@quicinc.com>
References: <20221219053844.4084486-1-quic_mkenna@quicinc.com>
To:     Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Abinaya Kalaiselvan <quic_akalaise@quicinc.com>,
        Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167767983108.16862.568764684446801499.kvalo@kernel.org>
Date:   Wed,  1 Mar 2023 14:10:34 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maharaja Kennadyrajan <quic_mkenna@quicinc.com> wrote:

> Add support to notify tx ack signal values for management
> packets to userspace through nl80211 interface.
> 
> Advertise NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT flag
> to enable this feature and it will be used for data
> packets as well.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Abinaya Kalaiselvan <quic_akalaise@quicinc.com>
> Signed-off-by: Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

01c6c9fccbd5 wifi: ath11k: Add tx ack signal support for management packets

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221219053844.4084486-1-quic_mkenna@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

