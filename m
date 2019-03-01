Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC16EC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 11:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABCFA20851
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 11:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbfCALL6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:11:58 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:46494 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbfCALL6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 06:11:58 -0500
Received: by mail-lj1-f180.google.com with SMTP id v16so20000581ljg.13
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2019 03:11:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dPi9EEkpnA92FcTCrZq44JZjyJ32lGD0eTrE0k5dWig=;
        b=BfJiL9jAsfxv5Rx+T7ukt3NKTe7vZCcFY1qdnGAe0vOf8qbW1EblQnGWQB3t2mm75b
         QKN8YRtn4xU4oRgoDq2rY16xxf6wRwTIGnEj1iqyEhmMv+JmiuK+s24pSADn6rL0l436
         UvolPnfZPn8GKRMt8SVKTclKSJCDxfMwOiwNVJZpLhCn2UEbaXekLS3V2rPDj4UOcNea
         70EETJ+SDd7zx2nf86gnaac6KELcZfXubD/23FvQ9AVANn1AEAh1mzB8mDZAuzcG3lf7
         YHCztN5k0Yn+PVppowahkfrvyPFcD3hqOJThzh/LoJUWjxLwHgBdi8g7FVtoEzi/YSQG
         IV2g==
X-Gm-Message-State: APjAAAUEzdPtbYf6tSw05YTrU9ARWCe/3WPva4KWNcwBKUkjJSkB80Rh
        LS+p6pWS2KjFtexGbg7diuaBFQ==
X-Google-Smtp-Source: APXvYqyGI1SFCI3+Mr5pdrgC0WSM8e+i2Kq0nIpIsm/ROlW3JRwHHShZ1EPLAegjZKcaxij5One0zg==
X-Received: by 2002:a2e:89c1:: with SMTP id c1mr2259982ljk.187.1551438716410;
        Fri, 01 Mar 2019 03:11:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c186sm3494444lfd.19.2019.03.01.03.11.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 03:11:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C2960183BB9; Fri,  1 Mar 2019 12:11:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: wireless workshop coming soon :-)
In-Reply-To: <f90f210372b8c7f7efae0c43ab3ae925c334bc0e.camel@sipsolutions.net>
References: <f90f210372b8c7f7efae0c43ab3ae925c334bc0e.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 01 Mar 2019 12:11:54 +0100
Message-ID: <871s3qn91h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> Please add your favourite topics to
>
> https://wireless.wiki.kernel.org/en/developers/summits/prague-2019
>
> I've added a few I think we should discuss at this stage, so also see if
> you have an opinion on those :-)

Cool! Could we schedule the scheduling and airtime fairness topics after
10:30? Have a tutorial to run in the morning and would obviously like to
participate in those discussions ;)

-Toke
