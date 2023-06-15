Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DBEEB64D9
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Jun 2023 07:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbjFOHqY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Jun 2023 03:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbjFOHqV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2023 03:46:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF96AC5;
        Thu, 15 Jun 2023 00:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CFAC611D1;
        Thu, 15 Jun 2023 07:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A369CC433C0;
        Thu, 15 Jun 2023 07:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686815180;
        bh=a6v+mcKiV2fdjJuioCgykVoWUW8Y6YLR1j9eu6QBcGw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=B6Ri01bQH0iNmkDI6LIAUk7aiVwheDcAxJzIP2E0IFyUA9YW9Elxmi6ESZSHkl23K
         G++hoDc2SrRlSHJcKbG3EXKnKsYcvJ8ClAHciy2Qak+LAL1MryGc0nd9/X1YuRABwR
         KpkNxbevdgPF563+yljrZwuLGdGOJO7388Hm6kRsQ3GC/YJ93W1csCQejBahs/6LqY
         L9PTzxsGc0uNjMRzno6So26jhTR0HYnRnGTwSThC0AayhVG4pBPBX3O5H5VTL5+rOI
         HgKLLTtB2weJg1DUOUP4vgdC3BZrLFcMOLcDR416KHURKCf6ME1hF2kej3Mov0vDwr
         +gjcIIsXMJDrQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rt2x00: fix the typo in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230612114612.1640-1-wangdeming@inspur.com>
References: <20230612114612.1640-1-wangdeming@inspur.com>
To:     Deming Wang <wangdeming@inspur.com>
Cc:     <stf_xl@wp.pl>, <helmut.schaa@googlemail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Deming Wang <wangdeming@inspur.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168681517414.8111.17808792357346522826.kvalo@kernel.org>
Date:   Thu, 15 Jun 2023 07:46:18 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Deming Wang <wangdeming@inspur.com> wrote:

> Fix typo in the description of 'non-succesfull'.
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-next.git, thanks.

52818fce28b2 wifi: rt2x00: fix the typo in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230612114612.1640-1-wangdeming@inspur.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

