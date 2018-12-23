Return-Path: <SRS0=iJrv=PA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780D8C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 00:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44A1021929
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Dec 2018 00:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393048AbeLWAu1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Dec 2018 19:50:27 -0500
Received: from maila.thecshore.com ([158.69.216.177]:57098 "EHLO
        maila.thecshore.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387711AbeLWAu1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Dec 2018 19:50:27 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2018 19:50:26 EST
Received: from finalmail.lan (finalmail.lan [10.50.50.83])
        by maila.lan (Postfix) with ESMTPS id 0B985DE5
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2018 19:42:18 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 maila.lan 0B985DE5
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.100.2 at maila.thecshore.com
Received: from [10.50.50.61] (danielpm.lan [10.50.50.61])
        by finalmail.lan (Postfix) with ESMTPSA id 9D645121B
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2018 19:42:17 -0500 (EST)
Subject: Out of order Re: to PATCH confused Patchwork (was Re: [PATCH] ath9k:
 Avoid OF no-EEPROM quirks without qca,no-eeprom)
To:     linux-wireless@vger.kernel.org
References: <20181222060913.28434-1-cshored@thecshore.com>
 <CAFBinCA3MTO=h9YpB0RkxSNy4ZpeYLOAuKTykAKz+68stAtMsg@mail.gmail.com>
From:   "Daniel F. Dickinson" <cshored@thecshore.com>
Message-ID: <8c9de333-a973-fea1-6919-888a6c177cb4@thecshore.com>
Date:   Sat, 22 Dec 2018 19:42:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAFBinCA3MTO=h9YpB0RkxSNy4ZpeYLOAuKTykAKz+68stAtMsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Greetings Patchwork admin/operator:

Patchwork didn't recognizing that the Re: went with the original 
[PATCH], even though In-Reply-To is correct.

This is because "[PATCH] ath9k: Avoid OF no-EEPROM quirks without 
qca,no-eeprom" <20181222060913.28434-1-cshored@thecshore.com>, there was 
a reply ("Re: [PATCH] ath9k: Avoid OF no-EEPROM quirks without 
qca,no-eeprom" 
<CAFBinCA3MTO=h9YpB0RkxSNy4ZpeYLOAuKTykAKz+68stAtMsg@mail.gmail.com>) 
which was accepted by the list before the patch.

It seems the list was refusing connections for some hours so my Bcc: to 
Martin Blumenstingl reached him long before the PATCH hit the list, and 
when it was back he's probably already on the whitelist for greylisting 
whereas I was greylisted.

I did look on the wireless wiki, patchwork site, and vger.kernel.org 
website to if there were any hints on how I could fix this, or who I 
could ping about it, but since I couldn't find such a link, I am posting 
to the applicable (this) list.

Regards,

Daniel
