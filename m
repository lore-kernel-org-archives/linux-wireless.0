Return-Path: <SRS0=QfV8=4B=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E6CC2BA83
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Feb 2020 09:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03C8B20848
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Feb 2020 09:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgBMJMu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:12:50 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:58444 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBMJMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Feb 2020 04:12:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j2AYC-008GOo-L5; Thu, 13 Feb 2020 10:12:48 +0100
Message-ID: <703b19463655cbb8a5ab9469caec5d3936dbe35d.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 1/2] cfg80211: skip strict validation for UDPATE_OWE
 command
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Thu, 13 Feb 2020 10:12:47 +0100
In-Reply-To: <20200213090657.28841-2-sergey.matyukevich.os@quantenna.com>
References: <20200213090657.28841-1-sergey.matyukevich.os@quantenna.com>
         <20200213090657.28841-2-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-02-13 at 09:07 +0000, Sergey Matyukevich wrote:
> Do not perform strict validation of UPDATE_OWE command.
> Otherwise, kernel rejects command executed by hostapd.

Can't we fix hostapd? I mean, it's a relatively new command, so why
shouldn't we validate it strictly?

johannes

