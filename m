Return-Path: <SRS0=TQ1a=2J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6958C43603
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Dec 2019 20:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E5524679
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Dec 2019 20:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfLSUzf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Dec 2019 15:55:35 -0500
Received: from nbd.name ([46.4.11.11]:33062 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSUzf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Dec 2019 15:55:35 -0500
Received: from pd95fd34f.dip0.t-ipconnect.de ([217.95.211.79] helo=[192.168.45.104])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1ii2pY-0008De-UE; Thu, 19 Dec 2019 21:55:33 +0100
Subject: Re: linux-next: Fixes tag needs some work in the wireless-drivers
 tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
References: <20191220075337.789971fe@canb.auug.org.au>
From:   John Crispin <john@phrozen.org>
Message-ID: <739b70e9-6a77-9d4e-2331-16022325cd34@phrozen.org>
Date:   Thu, 19 Dec 2019 21:55:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220075337.789971fe@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 19/12/2019 21:53, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>    485add35771b ("ath11k: fix pdev when invoking ath11k_wmi_send_twt_enable_cmd()")
> 
> Fixes tag
> 
>    Fixes: e65a616f4e74 ("ath11k: add TWT support")
> 
> has these problem(s):
> 
>    - Target SHA1 does not exist
> 
> Did you mean
> 
> Fixes: 6d293d447670 ("ath11k: add TWT support")
> 

My bad, sorry, I was sitting on an old tree apparently.
	John
