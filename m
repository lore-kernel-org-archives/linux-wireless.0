Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B41C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 14:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 735F22133F
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 14:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733168AbeLQOHS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 09:07:18 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:52776 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbeLQOHS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 09:07:18 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gYtYD-0003Gy-3E; Mon, 17 Dec 2018 15:07:17 +0100
Message-ID: <112ca7a8933b6113edf29e874d95207a22ccb790.camel@sipsolutions.net>
Subject: Re: wireless-regdb for automotive
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marcin Sielski <marcin.sielski@gmail.com>,
        linux-wireless@vger.kernel.org
Date:   Mon, 17 Dec 2018 15:07:15 +0100
In-Reply-To: <CANWiEciGLPxDc5JT0+gVrzEyEC6GOcUJUf8XR4PrYHj4TysHpA@mail.gmail.com> (sfid-20181216_131651_546089_82F4B6BF)
References: <CANWiEciGLPxDc5JT0+gVrzEyEC6GOcUJUf8XR4PrYHj4TysHpA@mail.gmail.com>
         (sfid-20181216_131651_546089_82F4B6BF)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2018-12-16 at 13:16 +0100, Marcin Sielski wrote:
> Hi,
> 
> Do you possibly have ideas how to adjust wireless-regdb package
> to support also automotive use cases as described in:
> https://www.efis.dk/documents/44659

You might want to explain what changes this requires ...

johannes

