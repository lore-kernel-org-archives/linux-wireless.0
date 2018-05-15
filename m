Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr40060.outbound.protection.outlook.com ([40.107.4.60]:31136
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751093AbeEOTAD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 15:00:03 -0400
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
To: Kalle Valo <kvalo@codeaurora.org>,
        Adrian Chadd <adrian@freebsd.org>
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
 <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
 <CAJ-VmonSEuh7Ou=K9Gu-gZ5ikpX9H=nzXe9NssNu1vw8fEk3hg@mail.gmail.com>
 <87h8naqel1.fsf@kamboji.qca.qualcomm.com>
 <CAJ-VmomNrjdEZ+UCH5rmth=2yE9utfM3FUTEy2a0zpq0r44Zig@mail.gmail.com>
 <87y3gla4re.fsf@codeaurora.org>
Cc: srirrama@codeaurora.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <a148127a-322a-8e48-cea4-bd9a8aa7c2ed@bowerswilkins.com> (sfid-20180515_210008_256605_67E9465B)
Date: Tue, 15 May 2018 11:59:45 -0700
MIME-Version: 1.0
In-Reply-To: <87y3gla4re.fsf@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Sure, every software change can cause regressions. But the thing is that
> this isn't an optional, ath10k has to have this to be able to continue
> using DFS channels.
>
Kalle, you said you don't know which exact FCC requirement this is for 
in another email thread.
Then how come you're sure this is not an optional and this approach is 
right one?

Peter
