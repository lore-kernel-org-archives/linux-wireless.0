Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B30C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 19:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF75A20880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 19:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfDHT56 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 15:57:58 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33702 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfDHT55 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 15:57:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDaOx-0006oc-MN; Mon, 08 Apr 2019 21:57:55 +0200
Message-ID: <98e1f8942056486669c6295323ef09763fd2ec0a.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/4] Extended Key ID support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 08 Apr 2019 21:57:54 +0200
In-Reply-To: <20190319203410.25145-1-alexander@wetzel-home.de>
References: <20190319203410.25145-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-03-19 at 21:34 +0100, Alexander Wetzel wrote:
> This patch series adds support for IEEE 802.11-2016 Extended Key ID
> support. Compared to the last RFC there are again quite some API
> changes, but also some bug fixes. (The bug fixes I remember are outlined
> in the different patches.)

FWIW, I've applied the first two patches here.

I'd really like you to continue with only that for now, and (try to) get
hostapd/wpa_supplicant changes upstream, perhaps with corresponding
hwsim tests. That way, we can see this working live.

We briefly discussed this at the wireless workshop, and the general
feeling seems to have been that the compat mode is probably not really
worthwhile, but I haven't quite made up my mind on that.

Still, having tests and being able to check it out would help a lot,
also as part of perhaps building a case for compat mode.

Thanks,
johannes

