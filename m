Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DF1E75450
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Oct 2023 11:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbjJCLiI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240514AbjJCLiG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2023 07:38:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20279E
        for <linux-wireless@vger.kernel.org>; Tue,  3 Oct 2023 04:38:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B6FC433CB;
        Tue,  3 Oct 2023 11:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696333083;
        bh=TyWVG6YmVpc/NCaci5sb6c+Agq+TUceCQkPuOM+wvVg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Tdjs3j0CVX/oiXMxubc1EMbPLKBPZn1aXVW2yWgSEnuR6Kq3XrecWiV/EGps0HSD7
         n9E/Dt+BVt2rdlUp1OGM1xccRldVGRNCV+4+VPnc0qQf1DeIAlOBaem07WzTsylTrk
         A/QbeL3bmkXhYrQAs9dkzA10iImTyz9WTfJwPCn0GzxGhf9o70v7zYqP39/37YnmzK
         u6F7MiJRnuPfef39agv6f3786tlVlvOt4Rbold193oOz32nln2uVTNjokAbo9T/eFn
         GueKC6S/WdCLJxyXFS0eAFIJ69HrPGyf0o+IFHGxgvUphvMH7Ea6s677mfTqLHcdVk
         YjByu12Q46huA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] wifi: rtw89: refine uplink trigger based control
 mechanism
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230929004024.7504-2-pkshih@realtek.com>
References: <20230929004024.7504-2-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <phhuang@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169633308054.28914.6636142876661235833.kvalo@kernel.org>
Date:   Tue,  3 Oct 2023 11:38:02 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Po-Hao Huang <phhuang@realtek.com>
> 
> Rename support_ul_tb_ctrl to waveform_ctrl since we need to do more
> trigger based control and the naming could be confusing. Move related
> code to leaf function so we make each functions separate and can be
> easier to maintain.
> 
> Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

2 patches applied to wireless-next.git, thanks.

ccd882042751 wifi: rtw89: refine uplink trigger based control mechanism
fc158f91360d wifi: rtw89: refine bandwidth 160MHz uplink OFDMA performance

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230929004024.7504-2-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

