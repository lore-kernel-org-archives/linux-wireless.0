Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389CEC433FE
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Mar 2022 20:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbiCPUko (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Mar 2022 16:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237873AbiCPUkn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Mar 2022 16:40:43 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3A85F8EB
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2022 13:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JydAo182gyjRHLyhjTxacxOJy7fSg0FYIifCLaWntUc=; b=lLzWufLH76b48Q57rCl1NbQcZp
        KjHPZ3Mw0eUTD0N2aay1UVbPFyQTyqZ7PxJAupTxiiZM3pqaBposOzCuzVm2mtOp6gDAF6E0AUqvb
        BIi0u1zvgEW0k+luzXehoU7hV6yqJFSMDQcjt2lI3zmoi74Z3eHkSwtUdZjgOmkgJ1a0=;
Received: from p200300daa7204f00592052c3a684cf4a.dip0.t-ipconnect.de ([2003:da:a720:4f00:5920:52c3:a684:cf4a] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nUaQX-00021G-Iu; Wed, 16 Mar 2022 21:39:25 +0100
Message-ID: <51ee5b67-b4d9-5f78-2729-9af6c7368df3@nbd.name>
Date:   Wed, 16 Mar 2022 21:39:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: pull request: mt76 2022-03-18
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <de917732-79c6-4ced-2761-f372ff5dea71@nbd.name>
In-Reply-To: <de917732-79c6-4ced-2761-f372ff5dea71@nbd.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 16.03.22 21:25, Felix Fietkau wrote:
> Hi Kalle,
> 
> here's a new last-minute pull request for 3.18
Heh, funny typo. 5.18 of course :)
