Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35270 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759837AbcISMcd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 08:32:33 -0400
Received: by mail-lf0-f66.google.com with SMTP id s64so8303394lfs.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 05:32:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mvj63b9y.fsf@purkki.adurom.net>
References: <CAJiC63F-O5KeCP+JZjW38uNDc=umXcOZVGma_SyiaTm70fGQ3A@mail.gmail.com>
 <87mvj63b9y.fsf@purkki.adurom.net>
From: Vidar Haarr <vidar@heidrunbryggeri.no>
Date: Mon, 19 Sep 2016 14:32:30 +0200
Message-ID: <CAJiC63GCor0casNZe32DBdR2_sBR=qrPTqr7GDZgCvKY8O_-Fg@mail.gmail.com> (sfid-20160919_143237_406649_8AA3BD9C)
Subject: Re: [athk9] beacon.c:642 ath9k_calculate_summary_state dump
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 17, 2016 at 3:29 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Vidar Haarr <vidar@heidrunbryggeri.no> writes:
>> sep. 17 11:38:36 edbpc kernel: WARNING: CPU: 0 PID: 1684 at
>> /home/kernel/COD/linux/drivers/net/wireless/ath/ath9k/beacon.c:642
>> ath9k_calculate_summary_state+0x135/0x390 [ath9k]
>
> Looks like exactly the same problem, but the fix (below) is not in
> v4.8-rc6. Should be in -rc7 which Linus hopefully releases on Sunday.
> Please test that and report if the problem continues.

Indeed, I did not check to see if -rc6 included it specifically, I
just checked github.com/torvalds/linux master branch to see if the fix
was there just before I sent the email to linux-wireless.
-rc7 seems to have resolved the issue.

Thank you,
-- 
Vidar
