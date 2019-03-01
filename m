Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B466C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 11:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A80D2085A
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 11:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732302AbfCALXU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:23:20 -0500
Received: from mail-ed1-f43.google.com ([209.85.208.43]:39708 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbfCALXT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 06:23:19 -0500
Received: by mail-ed1-f43.google.com with SMTP id p27so19702727edc.6
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2019 03:23:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MZUlK3pYX2rGCzENZccGo4CkZJ/KyYZPcSlksgvEVHQ=;
        b=ZVa7kquXX6r3gPvBQspMSDyl9Vf4C7V5qx1EXjC39u4RJLBgRHb4KkWPpFLV1Vp+57
         twXn9Gq6A7TEyA0Zu4jdn4/mazj62dsQb4aQOtwIQtLVT63asMGsjomZLk/Se6Prv7wS
         PJAzo1cUJDAFd4CD4HSD6J4AbK7Gfx6yVyHKi52GgZqYpJuatEt+5j5sHqMnxS760l8w
         d9MfIYO/i2uqNFKO+wO3XGOQycB1lzaoCJp7WJjPV19UUTlcpqAFh1QX1+xG90bwGM8J
         5o/uhUeUhxd5xr/N0ZsObcnAG0Bpz8rfqshyl90DKHTrhervbhgSr//v3ml2tYq2pF6Z
         uxMQ==
X-Gm-Message-State: APjAAAW93Q5t8HS6COEZY4N1mM3BCLgPro6wUv1FzD2dmRX2A75QZGE5
        GaiuPIpTMJ4SkEfSlR5IIWcRbA==
X-Google-Smtp-Source: APXvYqyyAbz59AsAKcxOM6bSEUDP+FchsRoSeCWma6xjwugOhXyb4HEbCZCgmsw0WrWWHS8hydUbOg==
X-Received: by 2002:a17:906:7210:: with SMTP id m16mr2746108ejk.171.1551439397827;
        Fri, 01 Mar 2019 03:23:17 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id o23sm1218972ejg.28.2019.03.01.03.23.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 03:23:16 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 74500183BB9; Fri,  1 Mar 2019 12:23:16 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: wireless workshop coming soon :-)
In-Reply-To: <5d26367411cf2b50d4cf237640598d1952f17673.camel@sipsolutions.net>
References: <f90f210372b8c7f7efae0c43ab3ae925c334bc0e.camel@sipsolutions.net> <871s3qn91h.fsf@toke.dk> <5d26367411cf2b50d4cf237640598d1952f17673.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 01 Mar 2019 12:23:16 +0100
Message-ID: <87y35ylty3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2019-03-01 at 12:11 +0100, Toke Høiland-Jørgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > Please add your favourite topics to
>> > 
>> > https://wireless.wiki.kernel.org/en/developers/summits/prague-2019
>> > 
>> > I've added a few I think we should discuss at this stage, so also see if
>> > you have an opinion on those :-)
>> 
>> Cool! Could we schedule the scheduling and airtime fairness topics after
>> 10:30? Have a tutorial to run in the morning and would obviously like to
>> participate in those discussions ;)
>
> Yeah, I'm aware. I also have a conflict with the netlink workshop, so
> Kalle will have to take over for me some of the time :-)

Great! Thought you probably were, just wanted an explicit ACK ;)

-Toke
