Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930A8C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 08:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 685F82089D
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 08:49:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 685F82089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbeKPTAw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 14:00:52 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:51006 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727567AbeKPTAw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 14:00:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gNZod-0007mN-0P; Fri, 16 Nov 2018 09:49:27 +0100
Message-ID: <c66fa62a88f1d99dc35019c5e7d00b062c6b1785.camel@sipsolutions.net>
Subject: Re: wiki: tree labels in patches
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 16 Nov 2018 09:49:26 +0100
In-Reply-To: <87in0x8l4t.fsf_-_@codeaurora.org> (sfid-20181116_094705_621436_7FEF9FE6)
References: <20181108150829.24842-1-zajec5@gmail.com>
         <87lg62cpno.fsf@codeaurora.org>
         <f1e1160ba35a42e12a0162629be23304@milecki.pl>
         <87in0x8l4t.fsf_-_@codeaurora.org> (sfid-20181116_094705_621436_7FEF9FE6)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-11-16 at 10:46 +0200, Kalle Valo wrote:

> Yes, I do see your FIX tag in patchwork:
> 
>  [ 31] [FIX] brcmfmac: fix reporting support for 160 MHz channels   2018-11-08 
> 
> But "FIX" is a bit ambigous as not all fixes not go to wireless-drivers,
> they can also go to wireless-drivers-next. So I prefer using the release
> number (or name of the tree) like this:
> 
> [PATCH 4.20] brcmfmac: fix reporting support for 160 MHz channels

FWIW, davem/networking just use 

[PATCH net]
[PATCH net-next]

which puts a bit more effort on the submitter but is a bit easier on the
maintainer I suppose. Also, not really a problem here, but it would help
disambiguate different trees on the same mailing list. I don't really
mind either way.

johannes

