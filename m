Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A06C4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Dec 2022 08:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbiLNIC1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Dec 2022 03:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiLNICX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2022 03:02:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0451EAE9
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2022 00:02:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB8061752
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2022 08:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68206C433D2;
        Wed, 14 Dec 2022 08:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671004941;
        bh=TdhhX5mo5F+m44dE+iKJI17Zo+Fpzyvj5Bw5zAasLOM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=exnClfQqLV0OXE3zcXodsxquz07wzH0NiADnI9wwJ+KjLytinbrowUOSqUN3dWW4U
         4kfnWZ2M79J3eYrZim58K5OX6e80McpzvGDMhYuKKl1URibXq92QeKyWXcYP1FZ1x3
         wwrDgF7OZhFILghUr9Nf17j6mAEpDCt5zJFmTsfkELHqCPseG1Xjz63pHqFLwD0rlI
         NKkv99gghVIWMeFv5YX3QkLxZGyaVG5f9QPPuqhG01SuvT8fcNYr1VjtJVbVSxtNIW
         9142Do+1ZzRC3fuc2kK3nDXHlguwF8CpZ0HpiWvwENVa7IkYCWjy8OPbRxM2ZxUVD/
         E0/l7Cv/zbtvw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Muna Sinada <quic_msinada@quicinc.com>
Cc:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        Aloka Dixit <quic_alokad@quicinc.com>
Subject: Re: [RFC 1/4] wifi: nl80211: advertise RU puncturing support to userspace
References: <1670006154-6092-1-git-send-email-quic_msinada@quicinc.com>
        <1670006154-6092-2-git-send-email-quic_msinada@quicinc.com>
Date:   Wed, 14 Dec 2022 10:02:18 +0200
In-Reply-To: <1670006154-6092-2-git-send-email-quic_msinada@quicinc.com> (Muna
        Sinada's message of "Fri, 2 Dec 2022 10:35:51 -0800")
Message-ID: <87tu1yl8fp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Muna Sinada <quic_msinada@quicinc.com> writes:

> From: Aloka Dixit <quic_alokad@quicinc.com>
>
> RU preamble puncturing is allowed for bandwidths more than 80 MHz
> except 80+80. Drivers may not support puncturing at all or have
> restrictions for a minimum bandwidth.
> Add new attribute NL80211_ATTR_RU_PUNCT_SUPP_BW to advertise the
> driver support to the userspace. Default value (0) will indicate that
> RU puncturing is not supported.
>
> Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>

Missing submitter's s-o-b.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
