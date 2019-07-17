Return-Path: <SRS0=8+dC=VO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDB7C76186
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jul 2019 09:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74F542173E
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jul 2019 09:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfGQJ2x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Jul 2019 05:28:53 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46038 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQJ2x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jul 2019 05:28:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hngF1-0007yt-Kl; Wed, 17 Jul 2019 11:28:51 +0200
Message-ID: <10ba3e3831e1ea253a8c63a30856278e65f88099.camel@sipsolutions.net>
Subject: Re: [PATCH] Add SPDX identifiers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yegor Yefremov <yegorslists@googlemail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 17 Jul 2019 11:28:50 +0200
In-Reply-To: <CAGm1_ku2Aicv1+k4PY+QkywsCAMWPDhsFWmy653+4ygGDQAdDg@mail.gmail.com> (sfid-20190717_112243_763087_B1EF417B)
References: <20190620130148.1674-1-yegorslists@googlemail.com>
         <90ccc515bb26b212b537fc1b0287afaa0f86fdf8.camel@sipsolutions.net>
         <CAGm1_ksic4xcVdaPAObwwNdaQ19E3ZiK97SkmVmp8kz6H2KpOw@mail.gmail.com>
         <693753473768100f07de573dd74bf4033618aed8.camel@sipsolutions.net>
         <CAGm1_kvK3eWnZk7eDOoqoAiedReJLunKfb4tvhqXU-hriO3itg@mail.gmail.com>
         <d47994158f5460104f36999f5f1c6251885af102.camel@sipsolutions.net>
         <CAGm1_ku2Aicv1+k4PY+QkywsCAMWPDhsFWmy653+4ygGDQAdDg@mail.gmail.com>
         (sfid-20190717_112243_763087_B1EF417B)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-07-17 at 11:22 +0200, Yegor Yefremov wrote:
> On Fri, Jun 28, 2019 at 3:58 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2019-06-24 at 22:32 +0200, Yegor Yefremov wrote:
> > > I have asked SPDX and this is their answer:
> > > https://lists.spdx.org/g/Spdx-legal/message/2631
> > 
> > Alright, thanks. I guess I can apply that then.
> 
> Should I change the patch or are you OK with it?

I'll take it, but I've been backlogged with merge work, sorry about
that.

johannes

