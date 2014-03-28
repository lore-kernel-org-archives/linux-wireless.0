Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48862 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaC1NW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:22:29 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so3655557wgg.9
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 06:22:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396012272.4175.27.camel@jlt4.sipsolutions.net>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-13-git-send-email-michal.kazior@tieto.com>
	<1396012272.4175.27.camel@jlt4.sipsolutions.net>
Date: Fri, 28 Mar 2014 14:22:28 +0100
Message-ID: <CA+BoTQ=i+XdwCcixiWTT9zchyLeXq2-rr5XbvWAVs1kXx=VjUQ@mail.gmail.com> (sfid-20140328_142232_904628_0C605DEC)
Subject: Re: [PATCH v2 12/13] mac80211: compute chanctx refcount on-the-fly
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 March 2014 14:11, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
>> It doesn't make much sense to store refcount in
>> the chanctx structure. One still needs to hold
>> chanctx_mtx to get the value safely. Besides,
>> refcount isn't on performance critical paths.
>>
>> This will make implementing chanctx reservation
>> refcounting a little easier.
>
> Why bother with patch 11 then?

I try to do one-thing-at-a-time. 11 is a fix, 12 is an enhancement. I
can squash it if you want?


Micha³
