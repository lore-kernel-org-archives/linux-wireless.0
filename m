Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A560C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6F92075D
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bJpykXXS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfBKRHM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:07:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46948 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbfBKRHM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 12:07:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tuz/peQyrw8+2UdmVaBV3u1U04EQtLDgMJunDDhMiYk=; b=bJpykXXSZ/u+Xf7R2evBgkE0fM
        u0lR20ABdBcFwcsyw4inHnLSlCxMnTfqrs020EAdCfDcZAYcZwDXPV6or74qpbBoVhxd5EyFxivcf
        LV58wUY9wdQ+fAXRi4wAF2TJz05VBn6oa1tW/HUbJMmUBeiKteqK2QePvLCwnpBC4FOiyzUQ4XFTj
        ynarh/zB2YTfGS73DJH6XHhexzLKI5iHunlUjv5VnFKaYA2AkTeR2q6tBzaWL6qk0XKVSaO4rJtHW
        flMSGvnrjIyG7IVo+V+9htQ5Fnhw8kCr6ccDiFf/UmmaV87QEE4jpDCnSa9uzL8g+w1auGCdnc/O7
        p7nhdh0w==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gtF30-0005rp-66; Mon, 11 Feb 2019 17:07:10 +0000
Subject: Re: linux-next: Tree for Feb 11 (wireless/80211)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20190211183951.3fe1dad9@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <80b32344-08c9-0d8b-fdae-1db9b1003f60@infradead.org>
Date:   Mon, 11 Feb 2019 09:07:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190211183951.3fe1dad9@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/10/19 11:39 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20190208:
> 

on i386:

ERROR: "__umoddi3" [net/wireless/cfg80211.ko] undefined!
ERROR: "__umoddi3" [net/mac80211/mac80211.ko] undefined!


-- 
~Randy
