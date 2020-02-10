Return-Path: <SRS0=uvCb=36=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B779EC352A4
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Feb 2020 08:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 959F8214DB
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Feb 2020 08:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgBJILc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Feb 2020 03:11:32 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:49422 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgBJILc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Feb 2020 03:11:32 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j14AE-00GoTH-Pr; Mon, 10 Feb 2020 09:11:31 +0100
Message-ID: <b5ac3a1aaa57cee8df1276d3a07d0f6f3f2ff207.camel@sipsolutions.net>
Subject: Re: [PATCH 0/8] iw: parse measurement pilot and fix scan bugs
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 10 Feb 2020 09:11:29 +0100
In-Reply-To: <20200209165902.44110-1-markus.theil@tu-ilmenau.de>
References: <20200209165902.44110-1-markus.theil@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2020-02-09 at 17:58 +0100, Markus Theil wrote:
> this
> series fixes several bugs found while fuzzing the scan code of iw.

Nice, can you describe the setup you used for this?

johannes

