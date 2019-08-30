Return-Path: <SRS0=jb13=W2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C47C3A5A4
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 10:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5724C21670
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 10:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfH3Kc5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:32:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34486 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfH3Kc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 06:32:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i3eDA-0003sV-4G; Fri, 30 Aug 2019 12:32:56 +0200
Message-ID: <420dcc9c0023791b72dba2d776045fc0b025597a.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Convert 6 GHz channel frequency to channel
 number
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Amar Singhal <asinghal@codeaurora.org>, jouni@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, jjohnson@codeaurora.org,
        rmanohar@codeaurora.org
Date:   Fri, 30 Aug 2019 12:32:55 +0200
In-Reply-To: <1567117290-19295-1-git-send-email-asinghal@codeaurora.org>
References: <1567117290-19295-1-git-send-email-asinghal@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-08-29 at 15:21 -0700, Amar Singhal wrote:
> Enhance function ieee80211_frequency_to_channel by adding 6 GHz
> channels.

Wait, this is already supported, no? Just implemented slightly
differently?

johannes

