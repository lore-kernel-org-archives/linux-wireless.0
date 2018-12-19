Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1D7C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37CA221841
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbeLSNfR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 08:35:17 -0500
Received: from mail.taht.net ([176.58.107.8]:33456 "EHLO mail.taht.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729314AbeLSNfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 08:35:16 -0500
Received: from dancer.taht.net (unknown [IPv6:2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.taht.net (Postfix) with ESMTPSA id 896182297B;
        Wed, 19 Dec 2018 13:35:13 +0000 (UTC)
From:   Dave Taht <dave@taht.net>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net
Subject: Re: [Make-wifi-fast] [PATCH v5 0/6] Move TXQ scheduling and airtime fairness into mac80211
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
        <877eg5hd8k.fsf@toke.dk>
Date:   Wed, 19 Dec 2018 05:34:59 -0800
In-Reply-To: <877eg5hd8k.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Wed, 19 Dec 2018 14:12:27 +0100")
Message-ID: <87mup1od18.fsf@taht.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke Høiland-Jørgensen <toke@toke.dk> writes:

> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>
>> All,
>>
>> Sorry for the long delay. Here is the consolidated series of mac80211,
>> ath9k and ath10k changes for moving TXQ scheduling and airtime fairness
>> into mac80211 and support airtime fairness.
>
> Thanks for taking care of the respin!
>
> Johannes, I think it's safe for you to review this version. I have
> started working on another approach for the scheduler algorithm itself,
> but it is fine to do as an incremental patch on top of this as it
> shouldn't impact the API. Having a separate patch also makes testing
> easier anyway. I'll see if I can't get it to a working state over the
> holidays...

There comes a time in all patch series where the best thing to do is
commit it, and inflict it on others. Now may be that time.

Acked-by: Dave Taht <dave.taht@gmail.com>

>
> -Toke
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast
