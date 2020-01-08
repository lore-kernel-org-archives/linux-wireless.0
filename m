Return-Path: <SRS0=curT=25=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC18C282DD
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Jan 2020 14:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA0782070E
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Jan 2020 14:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgAHOpw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 8 Jan 2020 09:45:52 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44534 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgAHOpw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Jan 2020 09:45:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ipCak-0061UM-Mp; Wed, 08 Jan 2020 15:45:50 +0100
Message-ID: <30cc55076b4c04b4c4ff9923535c3d3bbc037222.camel@sipsolutions.net>
Subject: Re: Possible deadlock in cfg80211
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>,
        linux-wireless@vger.kernel.org
Date:   Wed, 08 Jan 2020 15:45:49 +0100
In-Reply-To: <64dc212d-fde7-ab84-369c-c7cb5bf579d7@tu-ilmenau.de> (sfid-20200108_122337_992318_9DCD9168)
References: <64dc212d-fde7-ab84-369c-c7cb5bf579d7@tu-ilmenau.de>
         (sfid-20200108_122337_992318_9DCD9168)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-01-08 at 12:23 +0100, Markus Theil wrote:
> Hi,
> 
> while testing hostapd with hwsim, the following deadlock was reported:

I see you already sent a patch to fix this, thanks :)

johannes

