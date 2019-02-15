Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68003C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A6AC21B1A
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394019AbfBOLKk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:10:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38252 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389957AbfBOLKk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:10:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gubOA-00050P-OZ; Fri, 15 Feb 2019 12:10:38 +0100
Message-ID: <67c355e3b3078b55267c075d48b48bcb42435b11.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 00/12] Draft for Extended Key ID support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Feb 2019 12:10:36 +0100
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-02-10 at 22:06 +0100, Alexander Wetzel wrote:
> 
> The driver patches are - with the exception of the hwsim patch -
> definitely not ready for merge and mostly here to illustrate how the
> different APIs can be used and to start some discussions how to handle HW
> specific challenges. Of course if someone wants to play with Extended Key
> ID they also should be useful... (I can provide updated mostly working
> hostapd/wpa_supplicant patches if someone is interested.

Of course :-)

Some tests for the hwsim tests there would also be nice, that's the
easiest way to see something working - if you have them.

johannes

