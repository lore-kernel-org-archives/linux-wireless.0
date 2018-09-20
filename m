Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f182.google.com ([209.85.222.182]:45812 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbeIUBet (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 21:34:49 -0400
Received: by mail-qk1-f182.google.com with SMTP id q20-v6so2073519qkc.12
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 12:49:43 -0700 (PDT)
MIME-Version: 1.0
References: <1537430613-16849-1-git-send-email-rmanohar@codeaurora.org> <875zz08tah.fsf@toke.dk>
In-Reply-To: <875zz08tah.fsf@toke.dk>
From: Dave Taht <dave.taht@gmail.com>
Date: Thu, 20 Sep 2018 12:49:32 -0700
Message-ID: <CAA93jw6nNc_qwVexjybjQkrCcJcGmpesBO40D-fAaSJD5ZUTgg@mail.gmail.com> (sfid-20180920_214946_916032_793FB917)
Subject: Re: [RFC] mac80211: budget outstanding airtime for transmission
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kan Yan <kyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a side note (good work!) - I would dearly like to visibly account
for management frames somewhere that can be seen from userspace. ?
