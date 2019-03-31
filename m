Return-Path: <SRS0=EMPu=SC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13749C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 12:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A778D20830
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Mar 2019 12:39:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="vjE33Q+S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfCaMj5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 31 Mar 2019 08:39:57 -0400
Received: from webmail.newmedia-net.de ([185.84.6.166]:35986 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbfCaMj5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Mar 2019 08:39:57 -0400
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Mar 2019 08:39:57 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject; bh=o+jR5Ctc7aPsRbpEeek+ia4TLCG/XxHfx8dG+dwPYcY=;
        b=vjE33Q+SG+vXClTYX09Naf/cTLhUeil0LbdksFQr0GeyuhkJ9V8Wv/y5/IeboI90jVYAa5/Ha9z6bYgCqegllHS0d+Ur0D7TJBqXJICJyG9j1AbS5N/WjHPIKDwc1NXbPeXXnq2ZHJSN1UzUhgqHU/EneQSnxHUyrHyO+UIQpwo=;
Subject: Re: wil6210 new features support
To:     meneghello@dei.unipd.it, linux-wireless@vger.kernel.org
References: <20190329142607.Horde.d3GknYZ2mQFG07_UafOtL62@mail.dei.unipd.it>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <b47206e9-ba49-d5ad-a032-c1c9bf886877@newmedia-net.de>
Date:   Sun, 31 Mar 2019 14:23:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190329142607.Horde.d3GknYZ2mQFG07_UafOtL62@mail.dei.unipd.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [2003:c9:3f19:c600:7ca8:9bc7:aece:1d03]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1hAZVF-0005Sf-UT; Sun, 31 Mar 2019 14:23:57 +0200
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

radar detection on a 60 ghz card?  there is no requirement for it. radar 
is not operating at that frequencies

Am 29.03.2019 um 14:26 schrieb meneghello@dei.unipd.it:
>
> Good morning,
>
> we are working on OpenWrt support for wil6210 driver.
> We are interest in support for new features like radar.
> Is there any chance that this feature will be implemented in the next 
> version of the firmware?
> In case it is, can you share with us a beta version to do some testing?
>
> Thank you.
>
> Francesca Meneghello & Jacopo Pegoraro
>
>
