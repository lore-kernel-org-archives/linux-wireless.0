Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1966AC4332F
	for <linux-wireless@archiver.kernel.org>; Sun, 13 Nov 2022 18:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbiKMSn0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 13 Nov 2022 13:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbiKMSnZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Nov 2022 13:43:25 -0500
Received: from mog.warmcat.com (mog.warmcat.com [178.170.10.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AA4A101F6
        for <linux-wireless@vger.kernel.org>; Sun, 13 Nov 2022 10:43:22 -0800 (PST)
Received: from mx.warmcat.com (host31-53-12-215.range31-53.btcentralplus.com [31.53.12.215])
        by mog.warmcat.com (Postfix) with ESMTPSA id 5BE20135627;
        Sun, 13 Nov 2022 18:43:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mog.warmcat.com 5BE20135627
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=warmcat.com;
        s=default; t=1668365001;
        bh=3k9Eg2pOpd5AmIuw15f1aMnhaiz/9gS23FeGV/Hrjzs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PQ+UIwld0ltl8NdoBnF8Mz72SBjGHTjWJlvE1Wfxx9givOWWhAsaI9Z7pnTAzgFxW
         vNj+/nB4jaKv7pyGDF3e1JE3vohLbgy3+40SDZGpCOZa2K8bPAcBHuvGOdeScXo0pb
         L4B7PI9KnZfKTDeOdfRJoKnDEkfyu8E8f0FsXU5E=
Received: from [192.168.4.115] (unknown [192.168.4.115])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by mx.warmcat.com (Postfix) with ESMTPSA id CF6AD2A008F;
        Sun, 13 Nov 2022 18:43:20 +0000 (GMT)
Message-ID: <c0267b5a-accf-8d16-a50f-a80d29303e02@warmcat.com>
Date:   Sun, 13 Nov 2022 18:43:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: AP6275 / bcm43752 pcie on mainline brcmf
Content-Language: en-US
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Shengyu Qu <wiagn233@outlook.com>
Cc:     franky.lin@broadcom.com, linux-wireless@vger.kernel.org
References: <TY3P286MB26114DD461F50814980453E598029@TY3P286MB2611.JPNP286.PROD.OUTLOOK.COM>
 <08416710-655a-c87c-a599-3fe2563f7de4@warmcat.com>
 <18470a1e910.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <TY3P286MB26115A58795F264893CCB40198029@TY3P286MB2611.JPNP286.PROD.OUTLOOK.COM>
 <184720fc920.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Andy Green <andy@warmcat.com>
In-Reply-To: <184720fc920.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 11/13/22 17:35, Arend Van Spriel wrote:
> On November 13, 2022 4:52:45 PM Shengyu Qu <wiagn233@outlook.com> wrote:
> 
>> 在 2022/11/13 18:56, Arend Van Spriel 写道:

>>>> to basically work.  I realize it might not be easy to get an answer
>>>> internally but this chipset is likely to appear in more RK3588 SBCs 
>>>> soon
>>>> since it's the one on the evb.
>>>
>>> Right now I don't have enough information to comment on this.
>> Besides, could you upload the firmware that works with mainline driver
>> to linux-firmware repo?
> 
> I honestly don't know what entity provides the ampak wifi module. I 
> guess it is coming from Synaptics, but I am not sure. I rather fix the 
> mainline driver to make it work with the firmware (if possible) instead 
> of releasing a specific firmware for mainline.

That'd be great... I have some amount of time to help with this if 
something useful I can do for pcie case.

-Andy

