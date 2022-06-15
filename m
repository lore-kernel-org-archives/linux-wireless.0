Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B439C43334
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jun 2022 12:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349207AbiFOMtk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Jun 2022 08:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346821AbiFOMt0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Jun 2022 08:49:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558721AF37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2022 05:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD75B619A0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2022 12:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765C4C34115;
        Wed, 15 Jun 2022 12:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655297364;
        bh=BfoK1czbRdfUbda9qNE6nWM1RZzf0KrXxPi8M5/1/Z8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nN5cg9cymPhzO863zBV3eJxzPfGvPY70vfYgDhS+0MLPGzwLGvS8+cNxZYVGLnnMT
         vpp/XOEWFmbjqC6u2sjsUxVy/NkdXFFO3ZiyMHz6Xn7LAq1k5pV5flaGoWRxA+BzDx
         1qyf4nYf6w57d1vjxBJoMBQpLbviQIPYp1ecX1oPdYgM6/+MPSSy0FKIQPvSLI6sVk
         6cYemtpszCeduvXKtxVYmT1DZtIaSIxdEfC4iCNvFXgZodSQ0F4sl4wr5OpVeO86T0
         uy1T/EFw+69GEZiRyh74C3slVxt10QnHAEzk2zWqrKg/pTmYjToHalstj/XwZt8FMa
         wJ2EkIDhRYpXQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH wireless v2 1/2] dt-bindings: net: wireless: ath9k: Change
 Toke as maintainer
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220610133640.10810-1-kvalo@kernel.org>
References: <20220610133640.10810-1-kvalo@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165529735900.15724.10187059671742873369.kvalo@kernel.org>
Date:   Wed, 15 Jun 2022 12:49:23 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> wrote:

> From: Kalle Valo <quic_kvalo@quicinc.com>
> 
> Toke now maintains ath9k so update DT bindings as well.
> 
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>

2 patches applied to wireless.git, thanks.

f424b1a6e1b4 dt-bindings: net: wireless: ath9k: Change Toke as maintainer
c2b3a0759c76 dt-bindings: net: wireless: ath11k: change Kalle's email

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220610133640.10810-1-kvalo@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

