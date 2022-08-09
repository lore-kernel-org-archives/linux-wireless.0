Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B15C19F2D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Aug 2022 06:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiHIGBb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Aug 2022 02:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbiHIGB3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Aug 2022 02:01:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33859587
        for <linux-wireless@vger.kernel.org>; Mon,  8 Aug 2022 23:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F28160F5A
        for <linux-wireless@vger.kernel.org>; Tue,  9 Aug 2022 06:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2EBC433D6;
        Tue,  9 Aug 2022 06:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660024886;
        bh=nePK5bTooSEJxKEr7phBRCsVz/T9h0NnWhWdjLukIcc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U8yW1gGGA6pvj/Wn5ZN9qQIyGX6NYAC8Qkd6tI1ioIggK1av5x9tHQIc43+TVzaKV
         afKbAldFniYr8Gpr30ZjWxD6lYrizpJECXlQYczj0b28Wg+9qbuD/ZitHw4nFS0QWI
         eFWPt4Kaph7NHjHN5f8MSLWRVkM9k0JhreMdCMqK16R8ZQauEsFlAZL6n2qGUsouM1
         F/3tgH3CHjWxk2+GeQEHoyVoyj87nl4+bq3atfjM1A68r2sUDe8CDNj+aLsu6BKME0
         BimDwUY/o+3N5Yp+ON9a3hZAMbLQydVGXOnOOvYl9Vb2khQlxIDU85rK7U0NPT/Lo2
         PX4gjERgSft3A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: 8852a: correct WDE IMR settings
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220802123816.16685-1-pkshih@realtek.com>
References: <20220802123816.16685-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <leo.li@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166002488393.8958.1833570319701916344.kvalo@kernel.org>
Date:   Tue,  9 Aug 2022 06:01:25 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chia-Yuan Li <leo.li@realtek.com>
> 
> Correct IMR settings to let self error recover mechanism works accurately.
> 
> Signed-off-by: Chia-Yuan Li <leo.li@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

bafe9528b792 wifi: rtw89: 8852a: correct WDE IMR settings

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220802123816.16685-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

