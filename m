Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABC6C04A68
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jul 2022 12:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiG0M6x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Jul 2022 08:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiG0M6r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jul 2022 08:58:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C913ED55
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2022 05:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5AEF6164C
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2022 12:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BB2C433D6;
        Wed, 27 Jul 2022 12:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926726;
        bh=WjWKd2vAGfekDzs8siLjlngxg7YkCGeqCmdAtjyylQM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eBVd2t8BSvvPg3YHiShhFgcYey/hUsvCdjM9PNqlg35AUKkG8JAZnDgB2KJDO/wri
         wpU5dlQqZ/jjdGp+w0w1npVHQWLZZoUdkmgKqpvorH8AKsbN37In7QFsZsWWNHWNYP
         ucQOfHk1abACjMGMsN0CM8h1xLoUqoPvHWpkxA8RFe1RlBLWg+1q+EcJQdNnRTzZyt
         /Z7RKQAZe+ixDEaibcaPNLiQ6xF/6hMgRJ2UZEKEHoLE9+FeFYHr0sxxJeYUK1icYd
         6GOsZ6+XC8BlaVlhSrzMnk3peiA9vIVvCa4IuW8fzFw1N10conOqk4tdb9gKVmAzRf
         yy6/P4LG/1EGw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/8] wifi: wilc1000: add WID_TX_POWER WID in g_cfg_byte
 array
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220720160302.231516-2-ajay.kathat@microchip.com>
References: <20220720160302.231516-2-ajay.kathat@microchip.com>
To:     <Ajay.Kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Claudiu.Beznea@microchip.com>,
        <Sripad.Balwadgi@microchip.com>, <Ajay.Kathat@microchip.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892672164.11639.15796298694666761052.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 12:58:44 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Ajay.Kathat@microchip.com> wrote:

> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> WID_TX_POWER WID value is fetched from the firmware so it should be
> added in'g_cfg_byte' array to store the data which is received from
> firmware.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>

7 patches applied to wireless-next.git, thanks.

2f6e44ee6e96 wifi: wilc1000: add WID_TX_POWER WID in g_cfg_byte array
f589b5d941c7 wifi: wilc1000: set correct value of 'close' variable in failure case
33d4a577c7b1 wifi: wilc1000: set station_info flag only when signal value is valid
12fb1ae537a4 wifi: wilc1000: get correct length of string WID from received config packet
ad3e683ae4dc wifi: wilc1000: cancel the connect operation during interface down
39d0f1b0bf91 wifi: wilc1000: add 'isinit' flag for SDIO bus similar to SPI
4c2742146de0 wifi: wilc1000: use existing iftype variable to store the interface type

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220720160302.231516-2-ajay.kathat@microchip.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

