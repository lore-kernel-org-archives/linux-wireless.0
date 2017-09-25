Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932135AbdIYH7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 03:59:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Allen <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org
Subject: Re: [1/1] wireless: broadcom: brcm80211: use setup_timer() helper
References: <1505997786-12815-1-git-send-email-allen.lkml@gmail.com>
        <20170925074509.1168960719@smtp.codeaurora.org>
        <CAOMdWSLYb_LF=TS0jzCU6DC0KVfOa=pZYdMipBF_ynJ6N_0NmQ@mail.gmail.com>
Date: Mon, 25 Sep 2017 10:59:37 +0300
In-Reply-To: <CAOMdWSLYb_LF=TS0jzCU6DC0KVfOa=pZYdMipBF_ynJ6N_0NmQ@mail.gmail.com>
        (Allen's message of "Mon, 25 Sep 2017 13:21:11 +0530")
Message-ID: <87d16f6weu.fsf@kamboji.qca.qualcomm.com> (sfid-20170925_104605_708924_C9CB05D2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allen <allen.lkml@gmail.com> writes:

>>
>> Also your name in patchwork is just "Allen", without your lastname. I can fix
>> it this time, but please register to patchwork to fix your name. (Annoyingly
>> patchwork takes the name from it's database, not from the "From:" header)
>
>  Ah that's strange. I'll register again.

It's a frequent problem to have misconfigured name in patchwork. I guess
it happens as the first mail patchwork sees from you is the one stored
to the database. And if that mail has an incorrect name, that will be
used from that onwards. You have only onetime chance to fix it yourself
when you register to patchwork. After that only server admins can fix it
and you need to contact kernel.org helpdesk.

Apparently in recent versions of patchwork this should work better but
kernel.org hasn't updated it yet.

-- 
Kalle Valo
