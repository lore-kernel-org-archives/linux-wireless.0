Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8494C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 13:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F2C12186A
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 13:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfCONGd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 09:06:33 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:36733 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfCONGd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 09:06:33 -0400
Received: by mail-ed1-f49.google.com with SMTP id e4so7568983edi.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 06:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pURDYavJzBRdNyTeYifvNoSq2zc+zJRCX1mj7+Sbc/Q=;
        b=TfYaU9P2K6Ej6EMtxksPhDtZCzYvTDO6YQ6WRU7m1NOhElJZJPl3hQWIgLScD2kn5u
         LrZ4LzjDgLXyGBwFZMzR4ZMqo1kmpjnjbwgORAuIfchnARhy6dj1X5f1qm8Rn/QvSmgf
         U59+ijKfW4Pf+I52/C3O5a6DhWS2uC+dD91QW6j40KR1JlbLVLqYips5NjvZrv9TiTs5
         l39fQs8H/1UXmcQZC31HMrm2QWdDGdCPpqWUeJtS1j/rJmOYhzMXUWxsBCOYWZNFg7eD
         N/qFkkO3g/vJL182xCZRxHFQW3Dy+4alu9Gvsp0xwpAr2fxAnchL9RNaNAbjpHgXZ+Gh
         KZkg==
X-Gm-Message-State: APjAAAXennMDetZ4WA3Tqsj5nC6TDdvAESkmYUb2yaTe/7gJOsj5maDF
        NJBqieiNDEw54tHVcEn8/u5Xww==
X-Google-Smtp-Source: APXvYqxOT0+jkQISE51Lr0FzKqqZR0gzJKtSJOvqzFhdHV2u9wxU5zB/FtKAowplws4YjwgN3X9noA==
X-Received: by 2002:aa7:cd11:: with SMTP id b17mr2626062edw.118.1552655191498;
        Fri, 15 Mar 2019 06:06:31 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p4sm403183eja.40.2019.03.15.06.06.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 06:06:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0332F1804A2; Fri, 15 Mar 2019 14:06:29 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kevin Hayes <kevinhayes@chromium.org>,
        Kirtika Ruchandani <kirtika@google.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: wireless workshop coming soon :-)
In-Reply-To: <1d87a40795765be3ce9a485381c2867b143f26e1.camel@sipsolutions.net>
References: <f90f210372b8c7f7efae0c43ab3ae925c334bc0e.camel@sipsolutions.net> <871s3qn91h.fsf@toke.dk> <5d26367411cf2b50d4cf237640598d1952f17673.camel@sipsolutions.net> <87y35ylty3.fsf@toke.dk> <CAPJUEh3s-Bs6dKrDG54Q1Wu2+1+kwMvTDxJxxEAVBanLA0=FYA@mail.gmail.com> <1d87a40795765be3ce9a485381c2867b143f26e1.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 15 Mar 2019 14:06:29 +0100
Message-ID: <87wol0walm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sun, 2019-03-10 at 20:21 -0700, Kevin Hayes wrote:
>> [resending after html mode got nacked..]
>> 
>> Hi Johannes/Toke,
>> It would be fine with Kan and me to push the airtime fairness
>> discussion to later, to accomodate Toke.
>> Workshop fairness in action.  :)
>
> :)
> Yes, I know we need to do that. Unfortunately I haven't had a chance to
> really build up a time-based agenda.
>
> Let's see. We have track 4 all day on Wednesday, overlaps are:
>
>               | track 1 | track 2 | track 3
>  8:30 - 10:30 | TCP     | XDP tut | IoT / U-LPWA
> 10:50 - 11:50 | TCP     | Kubrnts | FRR
> 11:50 - 12:20 | netlink | QUIC    | FRR dataplane
> 13:20 - 14:20 | netlink | QUIC    | -
> 14:40 - 16:10 | TC      | NF      | -
> 16:30 - 18:00 | hw offl | preempt | -
>
> So the overlaps I know about are the XDP Tutorial (Toke) and netlink
> (partially at least, myself).
>
> Any others?
>
> Clearly Toke needs to be at the full XDP Tutorial, I think I can live
> with just doing the first part of the netlink workshop, according to
> their (tentative) agenda.
>
> As far as I'm concerned, we need Toke for the eBPF/XDP wifi topic, and
> clearly for all the topics related to TXQs, which includes at least part
> of HE/11ax. Toke, is there anything else you have a strong interest in?
>
>
> So tentatively, I'd say you can do w/o me for the FQ/airtime fairness
> stuff (right Toke, Kalle?) and talk about that at 11:50?
>
>
>
> Just randomly dropping the other stuff, I get:
>
> (T = no Toke, J = no Johannes)
>
>  8:30 -  9:00 T intro / CRDA deprecation / other regulatory topics?
>  9:00 -  9:30 T CSI reporting / vendor command/event handling updates
>  9:30 - 10:00 T nl80211 APIs - non-public features, NAN deprecation
> 10:00 - 10:30 T nl80211 APIs cont'd - Android
> 10:50 - 11:20   eBPF integration / XDP support for wifi
> 11:20 - 11:50   (buffer)
> 11:50 - 12:20 J rtw88 / grill Kalle (be)fore lunch ;-)
> 13:20 - 13:50   Kevin/Kan chromiumOS fairness review, bufferbloat plans
> 13:50 - 14:20   fq_codel / airtime fairness stack integration
> 14:40 - 15:10   HE/11ax status, timeline, testing, future work
> 15:10 - 15:40   HE/11ax TXQ AP-side (is anyone doing something here?)
> 15:40 - 16:10   release discussions (iw, wpa_s, ...)
> 16:30 - 17:00   security issue handling w/ backports
> 17:00 - 17:30   (buffer)
> 17:30 - 18:00
>
> WDYT?

SGTM :)

-Toke
