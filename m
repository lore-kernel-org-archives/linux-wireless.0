Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB05AEE49A0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Aug 2023 14:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbjHWOLA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Aug 2023 10:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbjHWOK7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2023 10:10:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCBAE57
        for <linux-wireless@vger.kernel.org>; Wed, 23 Aug 2023 07:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A01C661383
        for <linux-wireless@vger.kernel.org>; Wed, 23 Aug 2023 14:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62629C433C8;
        Wed, 23 Aug 2023 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692799856;
        bh=yC9A6Pv4rtofI95eEB8W+ozuM2EAqvZJ0OdTILRRsQo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U9JOd0pKUsLiqsAmdp2eGcxUj6EE3ltuuzRdDbHRhpyfTsmQIpMqGXf/HRCp17IcQ
         hfghxfnEGotS+0OSIzlZgGzARFS95EgT9uYZ5MOY5qISjCYscG6JewPl9bEruG+hHg
         kUM+cMfJEtoDNfWn2TYab1aIC3+WOWZpawqZBwAKFehpK32huuCBqKH8D4Q/ZJA3qN
         lisqW+7kpplkiJeqgNmQa6GSZnP7LVwO8d5p5BKTUDLzvPj9CNBNc1ed92zFNNPjlU
         riKznqgMfJw7aigu4VV+u9SwxtEyFZQAhIKx3qOMtodvCW5DbTO6Y+2dROxZCaFyU6
         xabDA2En7vgRw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: Remove unused declarations
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230811104413.33668-1-yuehaibing@huawei.com>
References: <20230811104413.33668-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <quic_jjohnson@quicinc.com>, <quic_srirrama@quicinc.com>,
        <yuehaibing@huawei.com>, <quic_mpubbise@quicinc.com>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169279985334.1241462.18271016040930398766.kvalo@kernel.org>
Date:   Wed, 23 Aug 2023 14:10:55 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> Commit 2c3960c2253d ("ath11k: setup ce tasklet for control path")
> declared but never implemented ath11k_ce_map_service_to_pipe().
> Commit e3396b8bddd2 ("ath11k: ce: support different CE configurations")
> declared but never implemented ath11k_ce_attr_attach().
> Commit d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> declared but never implemented ath11k_qmi_event_work()/ath11k_qmi_msg_recv_work().
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

adb0b206709f wifi: ath11k: Remove unused declarations

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230811104413.33668-1-yuehaibing@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

