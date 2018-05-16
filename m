Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51850 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753210AbeEPKJ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 06:09:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Peter Oh <peter.oh@bowerswilkins.com>
Cc: Adrian Chadd <adrian@freebsd.org>, srirrama@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
        <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
        <CAJ-VmonSEuh7Ou=K9Gu-gZ5ikpX9H=nzXe9NssNu1vw8fEk3hg@mail.gmail.com>
        <87h8naqel1.fsf@kamboji.qca.qualcomm.com>
        <CAJ-VmomNrjdEZ+UCH5rmth=2yE9utfM3FUTEy2a0zpq0r44Zig@mail.gmail.com>
        <87y3gla4re.fsf@codeaurora.org>
        <a148127a-322a-8e48-cea4-bd9a8aa7c2ed@bowerswilkins.com>
Date: Wed, 16 May 2018 13:09:51 +0300
In-Reply-To: <a148127a-322a-8e48-cea4-bd9a8aa7c2ed@bowerswilkins.com> (Peter
        Oh's message of "Tue, 15 May 2018 11:59:45 -0700")
Message-ID: <87wow3lxn4.fsf@kamboji.qca.qualcomm.com> (sfid-20180516_121011_097147_8BFE9F76)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <peter.oh@bowerswilkins.com> writes:

>> Sure, every software change can cause regressions. But the thing is that
>> this isn't an optional, ath10k has to have this to be able to continue
>> using DFS channels.
>
> Kalle, you said you don't know which exact FCC requirement this is for
> in another email thread. Then how come you're sure this is not an
> optional 

To me this is a mandatory ath10k feature because if the host driver does
not have this DFS channels won't work anymore.

> and this approach is right one?

That's something you need to ask the firmware team who designed and
implemented this.

This discussion is going circles, it would be a lot easier if you could
clearly say your point. But if your point is just "I don't like this"
then there's not much, if any, I can do about that.

-- 
Kalle Valo
