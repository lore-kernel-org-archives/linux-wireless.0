Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777A3C433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Apr 2022 07:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358796AbiD0HcE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Apr 2022 03:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358790AbiD0HcD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Apr 2022 03:32:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B23E75E52;
        Wed, 27 Apr 2022 00:28:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B2D7B82522;
        Wed, 27 Apr 2022 07:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D72C385A7;
        Wed, 27 Apr 2022 07:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651044530;
        bh=xLk9XWu/k/y+HAMQv3vTG9xohoGfdtDQLMATOYpRQt8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gS3OoIK9EZ1RArYZjN1MapVRm+myv9AfvjD12vQoZzNIv2tKOdcHRbgcLllfy57yZ
         VIKB8I35g9XDZve+1WoZv2IWtFdVVPR2sEmEvShFk1YOfdWpvidlynDMX0sCtRhMB+
         QIQRNJBjsOTSJB0YtCd4r4HVxMua2Y4K7V/v5Vy8XYVyZ0TFawXSzbqTEIf8SAAQm6
         LALClRl3YCxMMzpIv5d/c2XnR0hhAE/5x8m3RQBdP+dR3thLFOfLrSTWx0Q0A2mTI6
         G51yWjUTc9/9q8duMV+gLKr3FVSnJhELLcZ7VM4Q2HNpyOlNeHLyyZufzOPtVo20/x
         ZUpsMUOQPov8w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: simplify if-if to if-else
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220424094522.105262-1-wanjiabing@vivo.com>
References: <20220424094522.105262-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net,
        Wan Jiabing <wanjiabing@vivo.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165104452604.30072.1720851618351508731.kvalo@kernel.org>
Date:   Wed, 27 Apr 2022 07:28:47 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wan Jiabing <wanjiabing@vivo.com> wrote:

> Use if and else instead of if(A) and if (!A).
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

7471f7d273ac ath10k: simplify if-if to if-else

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220424094522.105262-1-wanjiabing@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

