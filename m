Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF21C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 14:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A3F2133D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 14:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbfDJOhS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:37:18 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60901 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731726AbfDJOhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 10:37:17 -0400
Received: from marcel-macpro.fritz.box (p4FF9F4D8.dip0.t-ipconnect.de [79.249.244.216])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1FC5FCEEAC;
        Wed, 10 Apr 2019 16:45:22 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH v2 0/4] Extended Key ID support
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <e8ad598e-a2c4-45be-6923-11fccf80d296@wetzel-home.de>
Date:   Wed, 10 Apr 2019 16:37:15 +0200
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7DC83094-7408-43FF-8070-2134C996E3D7@holtmann.org>
References: <20190319203410.25145-1-alexander@wetzel-home.de>
 <98e1f8942056486669c6295323ef09763fd2ec0a.camel@sipsolutions.net>
 <e8ad598e-a2c4-45be-6923-11fccf80d296@wetzel-home.de>
To:     Alexander Wetzel <alexander@wetzel-home.de>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ho Alexander,

>>> This patch series adds support for IEEE 802.11-2016 Extended Key ID
>>> support. Compared to the last RFC there are again quite some API
>>> changes, but also some bug fixes. (The bug fixes I remember are outlined
>>> in the different patches.)
>> FWIW, I've applied the first two patches here.
>> I'd really like you to continue with only that for now, and (try to) get
>> hostapd/wpa_supplicant changes upstream, perhaps with corresponding
>> hwsim tests. That way, we can see this working live.
> 
> That's splendid:-)
> I'll try to get the hostapd/wpa_supplicant patches finalized in the next weeks. Hopefully I have something to submit here once the Extended Key ID API is in mainline immediately.

have you tried to add Extended Key ID support into iwd?

Regards

Marcel

