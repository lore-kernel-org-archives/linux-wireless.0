Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05384C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0B6C20863
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfCYItz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 04:49:55 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36642 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729934AbfCYItz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 04:49:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h8LIo-0004vo-GU; Mon, 25 Mar 2019 09:49:54 +0100
Message-ID: <b781d983f2f5792a671a66075eaee6f3515aba6f.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: HE: add Spatial Reuse IE parsing support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Crispin <john@phrozen.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 25 Mar 2019 09:49:53 +0100
In-Reply-To: <20190325082057.26710-1-john@phrozen.org>
References: <20190325082057.26710-1-john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-03-25 at 09:20 +0100, John Crispin wrote:
> Add support to mac80211 for parsing SPR IEs as per
> P802.11ax_D3.0 section 9.4.2.241.

Hmm, if you're not going to use it, why parse it? Am I missing a follow-
up patch?

Also, consider checking against D4.0, Luca just sent a patch to update
to that for all the rest of the code.

johannes

