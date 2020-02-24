Return-Path: <SRS0=MKuk=4M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36D1C38BE2
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Feb 2020 19:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D400420836
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Feb 2020 19:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgBXTeP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Feb 2020 14:34:15 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:43242 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgBXTeP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Feb 2020 14:34:15 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6JUW-007Uzc-Jc; Mon, 24 Feb 2020 20:34:08 +0100
Message-ID: <f9530f24f221e2a5c2fe5dc20632b83ecbd87c86.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211-next next-2020-02-24
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Date:   Mon, 24 Feb 2020 20:34:06 +0100
In-Reply-To: <BCCC37CB-FA6D-433C-B772-EC46EF734FED@holtmann.org>
References: <20200224183442.82066-1-johannes@sipsolutions.net>
         <BCCC37CB-FA6D-433C-B772-EC46EF734FED@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-02-24 at 20:33 +0100, Marcel Holtmann wrote:
> 
> so I am bit concerned if these reverts are pushed so quickly without
> allowing ample time to discuss or review them on the mailing list. I
> for one, don’t agree with the assessment made to justify these
> reverts.

No no, you have it the wrong way around.

The reverts are pushed out quickly so that we _have_ time to argue and
come to an agreement on this, because otherwise we're locked in to the
API if we don't act ...

johannes

