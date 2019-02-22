Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B8AC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 19:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D791206BB
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 19:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfBVTKK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 14:10:10 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:51280 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfBVTKK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 14:10:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gxGD0-00040d-P1; Fri, 22 Feb 2019 20:10:06 +0100
Message-ID: <44add7675ef89dd61fcea9da6b55804c498a2d24.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Change default tx_sk_pacing_shift to 7
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Grant Grundler <grundler@google.com>,
        Kalle Valo <kvalo@codeaurora.org>, wgong@qti.qualcomm.com,
        ath10k@lists.infradead.org, wgong@codeaurora.org,
        Kan Yan <kyan@google.com>
Date:   Fri, 22 Feb 2019 20:10:05 +0100
In-Reply-To: <87imxcvt4z.fsf@toke.dk>
References: <20190221172936.21816-1-toke@redhat.com>
         <E1gx9x3-0002j0-1J@sipsolutions.net> <87lg28vup0.fsf@toke.dk>
         <a5151441bdfe02cb11043aa0786185b8ee3c3ee9.camel@sipsolutions.net>
         <87imxcvt4z.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-22 at 14:40 +0100, Toke Høiland-Jørgensen wrote:
> 
> And send it directly to stable, or does it need to go through you?

I added a Cc: stable tag. So all you really need to do is wait for the
emails telling you it failed to apply, and handle accordingly :)

johannes

