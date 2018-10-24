Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0C2C67863
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C117D2082E
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C117D2082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbeJXQDY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 12:03:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:50920 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbeJXQDX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 12:03:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gFDiN-0005ZN-Ex; Wed, 24 Oct 2018 09:36:27 +0200
Message-ID: <22674c9e06c5ebe6eef92c8aa9b7fef904208497.camel@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: pcie: align licensing to dual GPL/BSD
From:   Johannes Berg <johannes@sipsolutions.net>
To:     sedat.dilek@gmail.com
Cc:     linux-wireless@vger.kernel.org, joonwpark81@gmail.com,
        sgruszka@redhat.com, luto@amacapital.net, rajatja@google.com,
        kirtika@chromium.org
Date:   Wed, 24 Oct 2018 09:36:12 +0200
In-Reply-To: <CA+icZUW=jiTs9GPu-OgNnF1vaj=bHy88b5Qm3NnhkyKVdPqeLA@mail.gmail.com> (sfid-20181024_093355_425220_8F25C5E7)
References: <20181024070436.4466-1-johannes@sipsolutions.net>
         <CA+icZUW=jiTs9GPu-OgNnF1vaj=bHy88b5Qm3NnhkyKVdPqeLA@mail.gmail.com>
         (sfid-20181024_093355_425220_8F25C5E7)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-24 at 09:33 +0200, Sedat Dilek wrote:
> 
> > Align the licenses with their permission to clean up and to
> > make it all identical.
> > 
> 
> Does it make sense to put the BSD license (text) in a separate file
> (like GPL) and reference it?

I agree that it would, and in fact we already have it available to
reference with the SPDX in the LICENSES directory.

However, no files of the iwlwifi driver currently do that, and I'd
prefer doing that sort of cleanup more generally as a separate step.

johannes

