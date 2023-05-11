Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A524C7EE24
	for <linux-wireless@archiver.kernel.org>; Thu, 11 May 2023 10:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbjEKKM0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 May 2023 06:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236577AbjEKKMA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2023 06:12:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7B97EE9
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2023 03:11:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A23BE61820
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2023 10:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100A2C433D2;
        Thu, 11 May 2023 10:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683799917;
        bh=dokak5xIAJZxcGoevw3MS07l7wTn95UjyFXCNSaKY+I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AOZhyic38v+mpA+GH4Fmp9E1Ou7XkzowMk6khvvBXxac17O/IQz0YI8mmhvGGPPV7
         RjKtyQe38lTd+o0CcnyzXEgKy9RBHj6xn3MlT02mGn+Fa3pkMDxYFQUTOWzmMYDih8
         OkeEGv8yheUVXSD84uWEydrWeis+czGm9Rx1tQnK3D6ZRE5Zf52lD0EnywevJ5NxIE
         evqOMD/cLHzdZh/9lFPdfHBYvsX7mPUfQFJCKSG4ymVx5J4CZMqIKDkBUgBtw0X6Md
         jUU2A8/WRc4Hlbz+Sw4OolF92Xd2vn5wYs6R2JW+DG631I5KIvg61WcCKxYWMHfcki
         aOJzOGID/F19A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath11k: Relocate the func ath11k_mac_bitrate_mask_num_ht_rates() and change hweight16 to hweight8
References: <20230504092033.3542456-2-quic_mkenna@quicinc.com>
        <a409ded2-f6e5-bc74-3fdb-231a92d9bde5@quicinc.com>
Date:   Thu, 11 May 2023 13:11:52 +0300
In-Reply-To: <a409ded2-f6e5-bc74-3fdb-231a92d9bde5@quicinc.com> (Maharaja
        Kennadyrajan's message of "Wed, 10 May 2023 15:35:20 +0530")
Message-ID: <877ctfnpnb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maharaja Kennadyrajan <quic_mkenna@quicinc.com> writes:

> Ignore this patchset, I have sent the v2 version of this patchset by
> rebasing it on latest TOT.

Why? I had already applied v1 to the pending branch without issues:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=e3fd9d322448ee29c65a30e9bedaed222d7548b9

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=b7c3ee0ddc2bf3ecf511793aa55622a9aa62e420

Is there a reason why I should take v2 instead?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
