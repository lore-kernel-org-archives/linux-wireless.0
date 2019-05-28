Return-Path: <SRS0=DQ7G=T4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B5AC04AB6
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 07:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E472075B
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 07:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfE1HDI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 May 2019 03:03:08 -0400
Received: from nbd.name ([46.4.11.11]:57464 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfE1HDI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 May 2019 03:03:08 -0400
Received: from p5dcfb1b7.dip0.t-ipconnect.de ([93.207.177.183] helo=[192.168.45.104])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hVW8Y-0002iy-DC; Tue, 28 May 2019 09:03:06 +0200
Subject: Re: [PATCH V2] iw: print HE capabilities
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
References: <20190528065828.25356-1-john@phrozen.org>
 <2100673.vGQeuS8Cl6@bentobox>
From:   John Crispin <john@phrozen.org>
Message-ID: <c3a56b40-90c5-97b6-f350-729fe24408e8@phrozen.org>
Date:   Tue, 28 May 2019 09:03:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2100673.vGQeuS8Cl6@bentobox>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 28/05/2019 09:02, Sven Eckelmann wrote:
> On Tuesday, 28 May 2019 08:58:28 CEST John Crispin wrote:
>> Print the HE MAC/PHY capabilities and MCS/NSS sets.
>>
>> Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
>> Signed-off-by: John Crispin <john@phrozen.org>
>> ---
>> Changes in V2
>> * add a missing ',' in the iftypes name list
> The patch was already added with the bugfix [1].
>
> Kind regards,
> 	Sven
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/jberg/iw.git/commit/?id=c741be9f6ca34411c4dbeb03dd13e0dd794713a5


oh great, Thanks !


