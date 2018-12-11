Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4401EC07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 18:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B12020851
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 18:19:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B12020851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbeLKSTr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 13:19:47 -0500
Received: from muru.com ([72.249.23.125]:57492 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbeLKSTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 13:19:47 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id DD2458027;
        Tue, 11 Dec 2018 18:19:50 +0000 (UTC)
Date:   Tue, 11 Dec 2018 10:19:44 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ricardo Salveti <rsalveti@rsalveti.net>
Cc:     linux-wireless@vger.kernel.org, john.stultz@linaro.org
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
Message-ID: <20181211181944.GW39861@atomide.com>
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

* Ricardo Salveti <rsalveti@rsalveti.net> [181211 18:06]:
> John, did you have any similar issue on your test environment with
> kernel >= 4.19?

This sounds like the same issue that got fixed in the dts
earlier?

f904390ac8b2 ("arm64: dts: hikey: Define wl1835 power capabilities")

Regards,

Tony
