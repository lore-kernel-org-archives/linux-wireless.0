Return-Path: <SRS0=4Kz6=5J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F0FC4332B
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Mar 2020 12:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3B1A207FF
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Mar 2020 12:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgCXMw5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Mar 2020 08:52:57 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:40233 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbgCXMw4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Mar 2020 08:52:56 -0400
X-Originating-IP: 83.155.44.161
Received: from classic (mon69-7-83-155-44-161.fbx.proxad.net [83.155.44.161])
        (Authenticated sender: hadess@hadess.net)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id DF15EFF806;
        Tue, 24 Mar 2020 12:52:53 +0000 (UTC)
Message-ID: <6eaebae26615eaefa30817456d8d2b49bd12a5fc.camel@hadess.net>
Subject: Re: [PATCH resend 3] staging: rtl8188eu: Add rtw_led_enable module
 parameter
From:   Bastien Nocera <hadess@hadess.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Date:   Tue, 24 Mar 2020 13:52:53 +0100
In-Reply-To: <20200324124845.GB2401396@kroah.com>
References: <97d2ef68a6bcb7d1ece978eef6315e95732ca39d.camel@hadess.net>
         <20200324113840.GA2322042@kroah.com>
         <7aa74127978a73359ae95cd193bb3092d4536118.camel@hadess.net>
         <20200324123229.GD2348009@kroah.com>
         <9e67f1dd615b810e1725b13003fbb5d9000cd7c0.camel@hadess.net>
         <20200324124845.GB2401396@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.0 (3.36.0-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-03-24 at 13:48 +0100, Greg Kroah-Hartman wrote:
> 
<snip>
> Huh?  Why not fix this properly, as that's the only way this driver
> is
> ever going to be fixed up correctly and get out of staging at all.

Because, unfortunately, I have limited free time.

