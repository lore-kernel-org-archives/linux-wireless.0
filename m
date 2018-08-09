Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59754 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbeHINPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 09:15:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH wireless-drivers] mt76x0: Remove VLA usage
References: <20180807225040.GA2164@beast> <20180808092450.GA25772@redhat.com>
        <871sb942cx.fsf@kamboji.qca.qualcomm.com>
        <CAGXu5jKqeAHDWdNg++QJko5AM4g160kEQ54jLAojpRq6FszqgA@mail.gmail.com>
        <20180809104137.GA1955@redhat.com>
Date: Thu, 09 Aug 2018 13:51:09 +0300
In-Reply-To: <20180809104137.GA1955@redhat.com> (Stanislaw Gruszka's message
        of "Thu, 9 Aug 2018 12:41:38 +0200")
Message-ID: <87bmab3jaa.fsf@kamboji.qca.qualcomm.com> (sfid-20180809_125124_468224_1BA937AF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Wed, Aug 08, 2018 at 08:41:28AM -0700, Kees Cook wrote:
>> >> I thought SPDX line is needed only if file has no license and eeprom.c
>> >> file and other mt76x0 files have specified the license. Is SPDX still
>> >> needed in that case ?
>> 
>> I thought all source files needed SPDX: https://lwn.net/Articles/739183/
>
> Ok, goal is to have all kernel source files with SPDX header.

Yeah, it's a goal but I don't think it's a hard requirement yet. At
least I don't see it as a reason to reject patches.

And besides, mt76 uses ISC license and that's not in LICENSES directory.
So someone should add that first, and I think that patch should go via
Jonathan Corbet's tree (CCed).

-- 
Kalle Valo
