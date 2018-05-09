Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:35935 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935325AbeEIVgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:36:50 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [wl-testing/master] build regression in brcmfmac
In-Reply-To: <1525901454.6910.31.camel@sipsolutions.net>
References: <5AF36449.9050906@broadcom.com> <1525900945.6910.28.camel@sipsolutions.net> <874ljgzfht.fsf@toke.dk> <1525901454.6910.31.camel@sipsolutions.net>
Date: Wed, 09 May 2018 23:36:59 +0200
Message-ID: <87sh70y0hw.fsf@toke.dk> (sfid-20180509_233653_713607_F65E3923)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-05-09 at 23:27 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> That would be these:
>>=20
>> https://patchwork.kernel.org/patch/10389333/
>> https://patchwork.kernel.org/patch/10389331/
>> https://patchwork.kernel.org/patch/10389335/
>>=20
>
> D'oh, how did I miss that?!
>
> Your fixes line is slightly wrong, it should be
>
> Fixes: 12-digitid ("subject")

You mean it's missing the parenthesis?

-Toke
