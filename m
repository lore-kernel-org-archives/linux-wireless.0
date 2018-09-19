Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:58618 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbeITAtU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 20:49:20 -0400
Message-ID: <1537384189.10305.58.camel@sipsolutions.net> (sfid-20180919_211007_151897_E683CF90)
Subject: Re: [PATCH 5/7] netlink: prepare validate extack setting for
 recursion
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 19 Sep 2018 21:09:49 +0200
In-Reply-To: <20180919190851.GM4590@localhost.localdomain> (sfid-20180919_210856_964991_06B14B8E)
References: <20180919120900.28708-1-johannes@sipsolutions.net>
         <20180919120900.28708-6-johannes@sipsolutions.net>
         <18ea5293-5a12-7aca-7373-12d1ab3a0821@gmail.com>
         <1537374995.10305.47.camel@sipsolutions.net>
         <50773483-5732-8874-c5bf-99fa09d7e94a@gmail.com>
         <20180919190851.GM4590@localhost.localdomain>
         (sfid-20180919_210856_964991_06B14B8E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-19 at 16:08 -0300, Marcelo Ricardo Leitner wrote:
> 
> > If it fails and returns (nested and all) on the first failure it should
> > be fine. I was thinking something like this (whitespace damaged on paste):
> 
> This will avoid the situation that we were discussing in the older
> thread, btw.

I think it only avoids the part where we have to worry about "have I
already set this" - which is David's point AFAICT.

I'll reply over to your other email (as I already started writing a
reply there)

johannes
