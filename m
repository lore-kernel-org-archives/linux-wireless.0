Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EE9C433F5
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Sep 2021 07:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D23E60555
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Sep 2021 07:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbhIWHn0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 Sep 2021 03:43:26 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:53244 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239619AbhIWHnZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Sep 2021 03:43:25 -0400
Received: from sas1-a0ef9fa98917.qloud-c.yandex.net (sas1-a0ef9fa98917.qloud-c.yandex.net [IPv6:2a02:6b8:c08:b4a7:0:640:a0ef:9fa9])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 24FAA3C1FC0B
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2021 10:34:39 +0300 (MSK)
Received: from sas1-e20a8b944cac.qloud-c.yandex.net (sas1-e20a8b944cac.qloud-c.yandex.net [2a02:6b8:c14:6696:0:640:e20a:8b94])
        by sas1-a0ef9fa98917.qloud-c.yandex.net (mxback/Yandex) with ESMTP id nIxQKs7b4S-YdE474oC;
        Thu, 23 Sep 2021 10:34:39 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1632382479;
        bh=7HrIT46CipnedQKc3T0kNazocvbi4e7dObbWm/R0nK0=;
        h=Date:Message-ID:Subject:From:To;
        b=Wcbq3CYte1iLmtDW3d9Ue/Bq9uLir4oqQV88TlcLzBg8STGCVk0eH57LsEtGs+O6Y
         YArX+WTfUgwYGPK+7rm9Ln6YPR4I1Xn4gAUCIScXaxvxFI9YBH1xAjpsMUim9pkD3z
         LknjbayKTOREY+uOHzp6u+/EbYhu5g+sfse18eUg=
Authentication-Results: sas1-a0ef9fa98917.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Received: by sas1-e20a8b944cac.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id vjROL65IYm-Ycn4Ypr7;
        Thu, 23 Sep 2021 10:34:38 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     linux-wireless@vger.kernel.org
From:   Artem <dukzcry@ya.ru>
Subject: No AP mode for Mediatek MT7921
Message-ID: <f8bc7609-15b2-4d42-984b-50abd8da3b9d@ya.ru>
Date:   Thu, 23 Sep 2021 10:34:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello.

Are there any plans to implement Access Point mode in MT76 driver for 
MT7921 cards?

