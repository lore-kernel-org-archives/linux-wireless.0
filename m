Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92227C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B10B21570
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 08:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B10B21570
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=simonmicro.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbeI0O5c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 10:57:32 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:44565 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbeI0O5c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 10:57:32 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2018 10:57:31 EDT
Received: from mxback2g.mail.yandex.net (mxback2g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:163])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id E7F5240814B0;
        Thu, 27 Sep 2018 11:33:16 +0300 (MSK)
Received: from smtp4p.mail.yandex.net (smtp4p.mail.yandex.net [2a02:6b8:0:1402::15:6])
        by mxback2g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id CtP0kYOfP7-XG4OaxYh;
        Thu, 27 Sep 2018 11:33:16 +0300
Received: by smtp4p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id VFWKQ0KaOb-XEga5DUh;
        Thu, 27 Sep 2018 11:33:14 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: Problems and suggestions to the kernel module r8723bs
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <83c86a2a-0d2a-8119-2831-e9cfab7a43d7@simonmicro.de>
 <f0b67da4-747a-08e3-9744-fce2c74aaddc@lwfinger.net>
 <6e27de67-739f-ee17-eb5f-efb079d1f37f@simonmicro.de>
 <7a47d05c-2f3b-e4d5-ccf1-5c2106d3c93d@lwfinger.net>
From:   Simon Beginn <simonmicro@simonmicro.de>
Message-ID: <3a0468ee-e391-3b03-bfc5-36df484bce9d@simonmicro.de>
Date:   Thu, 27 Sep 2018 10:33:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <7a47d05c-2f3b-e4d5-ccf1-5c2106d3c93d@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Use the following command to get the baseline values: 
Done - aand nothing changes (The access point has a strength of -60dB on 
my desk). Well maybe the manufacturer has two antennas builtin. Yay - 
sorry for that.


> In dmesg
Yep, too late. I've already installed the necessary firmware-files. But 
I didn't wrote it, because the WiFi test wasn't performed until yet.


> o the work to get the driver into the condition necessary for it to be 
> in the regular tree. 
Did my patch made it?


Best regards,

Simon

