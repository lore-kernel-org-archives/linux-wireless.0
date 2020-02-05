Return-Path: <SRS0=U5kn=3Z=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64C6C352A2
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Feb 2020 18:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8B79217BA
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Feb 2020 18:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgBESOv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Feb 2020 13:14:51 -0500
Received: from nbd.name ([46.4.11.11]:60222 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbgBESOu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Feb 2020 13:14:50 -0500
Received: from [149.233.176.109] (helo=[10.255.231.27])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1izPCK-0000aK-FG; Wed, 05 Feb 2020 19:14:48 +0100
Subject: Re: [PATCH 1/2] ath11k: add thermal cooling device support
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
References: <1580860830-12696-1-git-send-email-pradeepc@codeaurora.org>
From:   John Crispin <john@phrozen.org>
Message-ID: <73391f93-a2c1-80b3-b77c-63c559f34326@phrozen.org>
Date:   Wed, 5 Feb 2020 19:14:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1580860830-12696-1-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Pradeep

1) do you plan to add the OF part so that we can run thermal_zones on 
top of this ?

2) what is the maximum number of levels that the HW supports ? looking 
at thermaltool it has to be at least 4 i guess ?
> +#define THERMAL_LEVELS  1

	John
