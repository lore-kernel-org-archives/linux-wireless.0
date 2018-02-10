Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52155 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbeBJN4o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 08:56:44 -0500
Received: from mail-pl0-f69.google.com ([209.85.160.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1ekVdz-0007Lr-8R
        for linux-wireless@vger.kernel.org; Sat, 10 Feb 2018 13:56:43 +0000
Received: by mail-pl0-f69.google.com with SMTP id 36so3873473plb.18
        for <linux-wireless@vger.kernel.org>; Sat, 10 Feb 2018 05:56:43 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH] ath9k: turn on btcoex_enable as default
From: Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <87k1vmeip8.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 10 Feb 2018 21:56:38 +0800
Cc: Felix Fietkau <nbd@nbd.name>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <E500FA42-23F1-433F-9BFB-78A2FD1946AF@canonical.com> (sfid-20180210_145708_662125_3CF55C3A)
References: <20180208052801.15670-1-kai.heng.feng@canonical.com>
 <56d650e6-d26f-087c-4e86-2e5d4e859414@nbd.name>
 <A5972CE9-8325-404A-A63D-ED29E44FB67B@canonical.com>
 <87k1vmeip8.fsf@kamboji.qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On 9 Feb 2018, at 3:16 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Sure, but we have to make sure that we don't create regressions on
> existing systems. For example, did you test this with any system which
> don't support btcoex? (just asking, haven't tested this myself)

No not really, but I will definitely test it.
The only module I have that uses ath9k is Dell’s DW1707.
How do I check if it support btcoex or not?

(I resend the mail because my last mail get changed to HTML by my mail client)

Kai-Heng

> 
> -- 
> Kalle Valo
