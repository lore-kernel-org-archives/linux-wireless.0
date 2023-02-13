Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F8EC636D4
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Feb 2023 14:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBMOnI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Feb 2023 09:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBMOnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2023 09:43:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AE71ABED
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2023 06:43:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D3E4610A4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2023 14:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF84DC4339B;
        Mon, 13 Feb 2023 14:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676299384;
        bh=Q2ZbejtjbvyKUQCUUuWoaFcjckbnXvOl2nLw/C7N5tQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BROkQb10XW0p+nXXrbI4k+0d5EzKH9o4QN84wXJO11cICFmso9MW9Q52Y1UcS9fNK
         ZxDrtOVgmSic7DwW/5TQr2w+yAY1DXqqGnKdWC3noud8Wtdx9gSAjLWCJK2rdxDJ9S
         t9uts589Sf8hdzCzGcKAi/GW8koJ4ToYgpShlUoHr2yvyvDvMUcMK5jBbHYhiv8mOR
         bS50UftK3p54fCE0E9yplACG0o5lp0h36fBWjOaHHDatzyagaI59x+sPc974E2dEfO
         KzslRwWF0Gpx11WdQMzLuOjuIvDvu4aO69ja+w7gJp3y091+haaezm4ei6YiWGyMya
         YcGvLPWYwg7lA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc:     linux-wireless@vger.kernel.org, lorenzo@kernel.org, nbd@nbd.name
Subject: Re: [PATCH] mt7915: handle FIF_MCAST_ACTION
References: <20230210171125.2996742-1-janusz.dziedzic@gmail.com>
Date:   Mon, 13 Feb 2023 16:42:57 +0200
In-Reply-To: <20230210171125.2996742-1-janusz.dziedzic@gmail.com> (Janusz
        Dziedzic's message of "Fri, 10 Feb 2023 18:11:25 +0100")
Message-ID: <87357962z2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Janusz Dziedzic <janusz.dziedzic@gmail.com> writes:

> Allow to receive Public Action frames when
> DPP_LISEN is in progress.
>
> Before we fail for STA interface.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>

Title missing "wifi: mt76:".

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
