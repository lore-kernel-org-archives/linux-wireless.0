Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00ECACD37B0
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Sep 2023 17:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjIRRCr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Sep 2023 13:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjIRRCj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2023 13:02:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA24C8E;
        Mon, 18 Sep 2023 10:02:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA83BC32787;
        Mon, 18 Sep 2023 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695047481;
        bh=8oCZ0wBkKK+50M3k5DKRDIJ4/8F2UdDzIsVH6iEwnDU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=q0HSu1mkH+tqCarz8XJQILDF0F7Cpv+omuE1ZWFQZBqZLXDQGmFmUdvA0ccbQ1RTt
         E2hwHERWSLnqrYiR9wwYEG89jE93w7MttaPOFRUfU+S1DW3X3oohzE1NDsS5/VJQsI
         zBxxWreZXnyHPEhITnKm90q2UkZcaG3TWqn1tYtSqDzuAxtmbpIAvMDOiEWI8qgeOG
         boIOqfwM9JuB6+4A/28x4lGCNG22LK2hNd8TdEuiyD2pEkXWXBXE2sIQR61hBLAlrr
         5+ntj11EvUXkzHg0teX2xqoKkCx4d6IOSiFsUaAqBI0F0O6x2Y8rkKF/fKNQrL+0fP
         bQx3h4Y2Cf7Ug==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtl8xxxu: Add a description about the device ID
 0x7392:0xb722
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230912053614.10644-1-zenmchen@gmail.com>
References: <20230912053614.10644-1-zenmchen@gmail.com>
To:     Zenm Chen <zenmchen@gmail.com>
Cc:     Jes.Sorensen@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtl8821cerfe2@gmail.com,
        Zenm Chen <zenmchen@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169504747757.740666.11200624028934392804.kvalo@kernel.org>
Date:   Mon, 18 Sep 2023 14:31:19 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Zenm Chen <zenmchen@gmail.com> wrote:

> According to the driver provided by EDIMAX, the device ID
> 0x7392:0xb722 belongs to EDIMAX EW-7722UTn V3, so add a comment about this.
> 
> Signed-off-by: Zenm Chen <zenmchen@gmail.com>

Patch applied to wireless-next.git, thanks.

c35642806830 wifi: rtl8xxxu: Add a description about the device ID 0x7392:0xb722

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230912053614.10644-1-zenmchen@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

