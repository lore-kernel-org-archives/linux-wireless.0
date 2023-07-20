Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6855AEB64DD
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Jul 2023 19:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjGTTME (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Jul 2023 15:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjGTTMC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2023 15:12:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8904D270C;
        Thu, 20 Jul 2023 12:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2036061BA7;
        Thu, 20 Jul 2023 19:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A884C433C8;
        Thu, 20 Jul 2023 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689880316;
        bh=80XQo1u1W5RBUzP6MVZbbNCR7TVpbsOFg3kZs+CSx5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X9pTtHbsq9+b1vbnbii14a8DTLligelcP6UaJ1moglWtfXWh5THhzh8W+Zqklo4Rz
         vRdB6O4BLBLxpe58Cm+7vKJ3ndX13B2bvhin1Gq257anNjmxZ71I7UwyOXu4KnjLOc
         R8kBklK4mb3XeAoIvHIWHbjYvar/H7CQUerpG8/IteGFTc/dE2UmIw2p8TM5IKCFMt
         Fj/eIzM4thyAdwdIBzNWcBJNj8uuYGolv36zj1v5kxWlXwv8v5nw9J7To6JIEGE6F+
         5Bml7SGsrlXNrU9Mt5qc4jp82zf1LdNrjStFJSORhVkD725WlVsTh1OJGPcOAZmk4A
         DQTzHfh+rLkrw==
Date:   Thu, 20 Jul 2023 15:11:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.4 03/26] wifi: rtw89: 8851be: add 8851BE PCI
 entry and fill PCI capabilities
Message-ID: <ZLmG+y9AMWxl68OG@sashalap>
References: <20230709151255.512931-1-sashal@kernel.org>
 <20230709151255.512931-3-sashal@kernel.org>
 <b8854720cdd2412b920c7b548d7eebd6@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b8854720cdd2412b920c7b548d7eebd6@realtek.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jul 10, 2023 at 12:25:24AM +0000, Ping-Ke Shih wrote:
>
>
>> -----Original Message-----
>> From: Sasha Levin <sashal@kernel.org>
>> Sent: Sunday, July 9, 2023 11:13 PM
>> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
>> Cc: Ping-Ke Shih <pkshih@realtek.com>; Kalle Valo <kvalo@kernel.org>; Sasha Levin <sashal@kernel.org>;
>> linux-wireless@vger.kernel.org
>> Subject: [PATCH AUTOSEL 6.4 03/26] wifi: rtw89: 8851be: add 8851BE PCI entry and fill PCI capabilities
>>
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>
>> [ Upstream commit 99ff8da56322cda9eb9b37021e27b127c2d1cad8 ]
>>
>> Add PCI entry to 8851BE with its device ID 10ec:b851, also fill PCI info
>> according to its capabilities.
>>
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> Signed-off-by: Kalle Valo <kvalo@kernel.org>
>> Link: https://lore.kernel.org/r/20230421024551.29994-3-pkshih@realtek.com
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please don't take this patch to 6.4, 6.3, 6.1, and other stable branches.
>With this patch, it still can't enable 8851BE, so let kernel 6.5 to be the
>first version that supports 8851BE.

Dropped, thanks!

-- 
Thanks,
Sasha
