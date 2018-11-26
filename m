Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E054C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 09:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D56820850
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 09:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D56820850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbeKZUhz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 15:37:55 -0500
Received: from a3.inai.de ([88.198.85.195]:34796 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbeKZUhz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 15:37:55 -0500
Received: by a3.inai.de (Postfix, from userid 25121)
        id 15ABC3BACCB1; Mon, 26 Nov 2018 10:44:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 0E5563BB8A94;
        Mon, 26 Nov 2018 10:44:21 +0100 (CET)
Date:   Mon, 26 Nov 2018 10:44:21 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Kalle Valo <kvalo@codeaurora.org>
cc:     marcel@holtmann.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ell:: build: bump SO version of libell
In-Reply-To: <87a7lw9yin.fsf@purkki.adurom.net>
Message-ID: <nycvar.YFH.7.76.1811261034260.25275@n3.vanv.qr>
References: <20181124131258.15978-1-jengelh@inai.de> <87a7lw9yin.fsf@purkki.adurom.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday 2018-11-26 06:52, Kalle Valo wrote:

>> diff --git a/Makefile.am b/Makefile.am
>> index d115360..5a44f40 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -8,8 +8,8 @@ ACLOCAL_AMFLAGS = -I build-aux
>>  # Interfaces added:		CURRENT++ REVISION=0 AGE++
>>  # Interfaces removed:		CURRENT++ REVISION=0 AGE=0
>>  
>> -ELL_CURRENT = 0
>> -ELL_REVISION = 2
>> +ELL_CURRENT = 1
>> +ELL_REVISION = 0
>>  ELL_AGE = 0
>>  
>>  pkginclude_HEADERS = ell/ell.h \
>
>For what project is this? I can't figure out why this was sent to
>linux-wireless, maybe by mistake?

"Subject: [PATCH] ell:: build: bump SO version of libell"
                  ^^^                             ~~~^^^
=> https://mirrors.kernel.org/pub/linux/libs/ell/
=> https://git.kernel.org/pub/scm/libs/ell/ell.git/

ell is used by iwd (deals with wireless) and bluez (deals with 
bluetooth, another wireless tech). Its hosting on kernel.org suggested a 
vger mailing list is appropriate for being .. in Cc.
Now that I am looking at the mail again, it appears I forgot specifying 
that other list at 01.org.
