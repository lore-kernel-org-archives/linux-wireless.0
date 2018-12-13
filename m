Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C12C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D59D20851
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ebGsI27P";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gt5/Vd/Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D59D20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbeLMOUz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:20:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33596 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727618AbeLMOUz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:20:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 85E1360237; Thu, 13 Dec 2018 14:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544710854;
        bh=Y29sGIEzAqbJPc1HJ9U69KNwfZgpwCj8l0cnLvC61Z8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ebGsI27PmjIsazas1B3tLF+y9SZcg6QILRiW6voFrmTi2OsIB+IaeOrbB41CjoAeF
         mzC9kc0oCw54jNPSt3Zzi14R65RNZaYAAm/JqGEpz0R5bdVt+QFnCr1aE6Mhc43YVg
         uw2pbfPPT9NlvNX8M4dfLDXUaekLSW2vO/B9uu5E=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 639E56013C;
        Thu, 13 Dec 2018 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544710854;
        bh=Y29sGIEzAqbJPc1HJ9U69KNwfZgpwCj8l0cnLvC61Z8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=gt5/Vd/ZTZjnPfJ2/RQNhHvWG0R8lhH5eLEPMe5GxlA5gGEDQ2mZRF8caWZF1tNsn
         zDdbjdkch4krZ8UDKozI5QpLxqp186RWns/j9Mfzn7R9tDK6qfa6xuJRxSpmxv8CYn
         7LCpZJCIxuSsaQt7c/iLI/jVrKuJhCnFEgYGcZCw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 639E56013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt76: add entry in MAINTAINERS file
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <47d46d5627fee5691f7faf682d385c2aa3a537d4.1544456498.git.lorenzo.bianconi@redhat.com>
References: <47d46d5627fee5691f7faf682d385c2aa3a537d4.1544456498.git.lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213142054.85E1360237@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:20:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Add entry for mt76 driver in MAINTAINERS file
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers.git, thanks.

cddfb283af7e mt76: add entry in MAINTAINERS file

-- 
https://patchwork.kernel.org/patch/10721465/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

