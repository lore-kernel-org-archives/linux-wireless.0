Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C20EC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 08:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 480E920663
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 08:47:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 480E920663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbeKZTkz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 14:40:55 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59676 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeKZTkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 14:40:55 -0500
Received: from marcel-macbook.fritz.box (p4FEFC449.dip0.t-ipconnect.de [79.239.196.73])
        by mail.holtmann.org (Postfix) with ESMTPSA id 2C432CEE9E;
        Mon, 26 Nov 2018 09:54:59 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.1 \(3445.101.1\))
Subject: Re: [PATCH] ell:: build: bump SO version of libell
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <87a7lw9yin.fsf@purkki.adurom.net>
Date:   Mon, 26 Nov 2018 09:47:18 +0100
Cc:     Jan Engelhardt <jengelh@inai.de>, linux-wireless@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EF376AD0-222C-4039-B78A-E69BBF49718B@holtmann.org>
References: <20181124131258.15978-1-jengelh@inai.de>
 <87a7lw9yin.fsf@purkki.adurom.net>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3445.101.1)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

>> Commit 0.13-7-g4a386a1 changed the ABI of l_signal_create. This
>> warrants a bump in the SO version.
>> ---
>> Makefile.am | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Makefile.am b/Makefile.am
>> index d115360..5a44f40 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -8,8 +8,8 @@ ACLOCAL_AMFLAGS = -I build-aux
>> # Interfaces added:		CURRENT++ REVISION=0 AGE++
>> # Interfaces removed:		CURRENT++ REVISION=0 AGE=0
>> 
>> -ELL_CURRENT = 0
>> -ELL_REVISION = 2
>> +ELL_CURRENT = 1
>> +ELL_REVISION = 0
>> ELL_AGE = 0
>> 
>> pkginclude_HEADERS = ell/ell.h \
> 
> For what project is this? I can't figure out why this was sent to
> linux-wireless, maybe by mistake?

it should have gone to ell@lists.01.org.

Regards

Marcel

