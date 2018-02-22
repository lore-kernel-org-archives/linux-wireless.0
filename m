Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47413 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753070AbeBVKLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 05:11:55 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] Export TXQ parameters and statistics via nl80211
In-Reply-To: <5A8DCE3B.3000607@broadcom.com>
References: <20180219170224.14816-1-toke@toke.dk> <5A8D3445.3040300@broadcom.com> <87bmgiboan.fsf@toke.dk> <5A8DCE3B.3000607@broadcom.com>
Date: Thu, 22 Feb 2018 11:11:53 +0100
Message-ID: <87o9kh9vva.fsf@toke.dk> (sfid-20180222_111208_670124_DE304746)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

>>> So can we expect some manual in which is described what parameter
>>> should be tweaked based on the retrieved statistics.
>>
>> Heh, not sure I'll promise a whole manual, but I am happy to write a
>> blog post (or wiki page if that's better) explaining what these values
>> mean and what insight one might gain from them.
>
> My preference would be to have something on wireless.wiki.kernel.org. 
> Another option might be to add kerneldoc section for this.

Sure, I can add a page on the wiki about TXQs :)

-Toke
