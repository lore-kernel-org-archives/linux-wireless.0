Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:51961 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbeDSJK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 05:10:29 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Bernhard Gabler <Bernhard_Gabler@web.de>,
        Linux-Wireless mailing list <linux-wireless@vger.kernel.org>
Subject: Re: ath confusing log message "country IE"
In-Reply-To: <1524085061.3024.8.camel@sipsolutions.net>
References: <660b1538-0ccb-8f1a-ebe0-632b0e14a46b@web.de> <87o9ig1s3o.fsf@toke.dk> <1524085061.3024.8.camel@sipsolutions.net>
Date: Thu, 19 Apr 2018 11:10:27 +0200
Message-ID: <877ep31rzw.fsf@toke.dk> (sfid-20180419_111032_988013_8961046C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-04-18 at 16:55 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> Heh, that is a good point, I think. The patch below should fix it; but I
>> worry that the log lines become quite long, then? Maybe better to use
>> "country-IE", but that could also be confused. "country inf.elem"
>> perhaps?
>
> Heh. Drop "information" entirely, the spec also did :-)
>
> 802.11-2016 just says
>
> 9.4.2 Elements
> [...]
> 9.4.2.9 Country element

Ah, excellent. Will send a proper patch :)

-Toke
