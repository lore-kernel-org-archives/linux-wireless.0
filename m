Return-Path: <SRS0=iJrv=PA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E861CC43387
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 03:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABC3E21920
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 03:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393084AbeLWDDV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Dec 2018 22:03:21 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.228]:29098 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732371AbeLWDDV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Dec 2018 22:03:21 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 4CB80A046
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2018 21:03:20 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id au2yglloD90onau2ygJDWJ; Sat, 22 Dec 2018 21:03:20 -0600
X-Authority-Reason: nr=8
Received: from [189.250.106.44] (port=46936 helo=[192.168.1.76])
        by gator4166.hostgator.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gau2x-002VNv-VH; Sat, 22 Dec 2018 21:03:20 -0600
Subject: Re: [PATCH] nfc: af_nfc: Fix Spectre v1 vulnerability
To:     David Miller <davem@davemloft.net>
Cc:     sameo@linux.intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181221214753.GA2799@embeddedor>
 <20181222.150946.778308321544627589.davem@davemloft.net>
 <db8937bf-3dd3-f498-d983-ee98582d9f75@embeddedor.com>
 <20181222.184217.692941087610805245.davem@davemloft.net>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <d0f814ce-80a4-c350-3b37-81afcb3f9845@embeddedor.com>
Date:   Sat, 22 Dec 2018 21:03:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181222.184217.692941087610805245.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.106.44
X-Source-L: No
X-Exim-ID: 1gau2x-002VNv-VH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.76]) [189.250.106.44]:46936
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 12/22/18 8:42 PM, David Miller wrote:
> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> Date: Sat, 22 Dec 2018 17:37:35 -0600
> 
>> I wonder if you can take this one too:
>>
>> https://lore.kernel.org/lkml/20181221212229.GA32635@embeddedor/
>>
>> It's pretty similar to the af_nfc one.
> 
> Sure, done.
> 

Great. Thanks.
--
Gustavo
