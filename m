Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F73C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 14:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24C6E21871
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 14:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbeLROIm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 09:08:42 -0500
Received: from mail.taht.net ([176.58.107.8]:33302 "EHLO mail.taht.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbeLROIl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 09:08:41 -0500
Received: from dancer.taht.net (unknown [IPv6:2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.taht.net (Postfix) with ESMTPSA id E9D4121455;
        Tue, 18 Dec 2018 14:08:38 +0000 (UTC)
From:   Dave Taht <dave@taht.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Louie Lu <me@louie.lu>, rmanohar@codeaurora.org,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to TXQs
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
        <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
        <CADMDV=zX4NuyDS+C==c8iq7FagGLFOoQ-Fjf=x-zmehJAz8=zQ@mail.gmail.com>
        <87va4ytgff.fsf@toke.dk>
        <5d46e8942ea151b211651588db3dacb97e6e5a53.camel@sipsolutions.net>
Date:   Tue, 18 Dec 2018 06:08:22 -0800
In-Reply-To: <5d46e8942ea151b211651588db3dacb97e6e5a53.camel@sipsolutions.net>
        (Johannes Berg's message of "Tue, 18 Dec 2018 13:11:27 +0100")
Message-ID: <87a7l30vxl.fsf@taht.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2018-11-15 at 09:10 -0800, Toke Høiland-Jørgensen wrote:
>> Louie Lu <me@louie.lu> writes:
>> 
>> > Hi Rajkumar, Toke,
>> > 
>> > I found the series (v3,4/6) remove the debugfs remove reset
>> > station's
>> > airtime method, and didn't added at here.
>> > 
>> > Not sure how to help this kind of situation, do I need a separate
>> > patch to fix this, or posting the patch here is fine?
>> 
>> This is fine; we can fold it into the next version. Thanks :)
>
> Just FYI - I'm going to assume, given this comment and the long
> discussion, that there will be a next version :)

I think toke's still sleeping off the post graduation hangover.

>
> johannes
>
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast
