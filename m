Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A179C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 10:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D08AE20854
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 10:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cXgNvxV/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cXgNvxV/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCNKDs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 06:03:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47896 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfCNKDs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 06:03:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 79C2A602A7; Thu, 14 Mar 2019 10:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552557827;
        bh=sQBgJ/3CyZjFefrNnfu3lfaUF224PbG0pEmnaH3Gidg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cXgNvxV/84yLF6Z9NMxUlLQgjuJsyuP8natOZSlXyr/P/NXlpnPM5NzTVcDI1sdwm
         7rTEdOnoXa1MrIgiZ8PFTpKPa4SU0X2PP0ktw38Iml8M7iKH0n4vAwwDZQf4TLBUFX
         ZTJk2b8Hz3LcBGObamO2+VWw8uVW0i5Fn5IviL5I=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 1B07B6016D;
        Thu, 14 Mar 2019 10:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552557827;
        bh=sQBgJ/3CyZjFefrNnfu3lfaUF224PbG0pEmnaH3Gidg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cXgNvxV/84yLF6Z9NMxUlLQgjuJsyuP8natOZSlXyr/P/NXlpnPM5NzTVcDI1sdwm
         7rTEdOnoXa1MrIgiZ8PFTpKPa4SU0X2PP0ktw38Iml8M7iKH0n4vAwwDZQf4TLBUFX
         ZTJk2b8Hz3LcBGObamO2+VWw8uVW0i5Fn5IviL5I=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 14 Mar 2019 12:03:47 +0200
From:   merez@codeaurora.org
To:     Robert Marko <robimarko@gmail.com>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: wil6210 firmware version
In-Reply-To: <CAOX2RU5igDk_nkj74i-1_hoC4JbSSK3w1_-DyH+3EzyeMHnMcw@mail.gmail.com>
References: <CAOX2RU5igDk_nkj74i-1_hoC4JbSSK3w1_-DyH+3EzyeMHnMcw@mail.gmail.com>
Message-ID: <0aabbc6e74fefa8bd5a094dc84b1f87c@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-14 11:07, Robert Marko wrote:
> Hi,
> I am working on OpenWrt support for device using wil6210 card.
> I am using firmware and board file provided in linux-firmware for its
> development but it appears tha most of newer features that driver
> enables are firmware dependant and version 5.2 in linux-firmware is
> too old to expose those.
> 
> Is there any chance of QCA pushing updated version to linux-firmware?
> 
> Thanks
> Robert Marko

Is there any specific feature you are interested in?

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
