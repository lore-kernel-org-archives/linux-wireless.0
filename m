Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44872 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbdERMiI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 08:38:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        David Miller <davem@davemloft.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Roman Yeryomin <roman@advem.lv>
Subject: Re: [PATCH] rt2x00: remove unneccesary code
References: <CAKR_QVJBSKw2uCY4RbHZPvbGkMcvnBh+j6F+9t93mG3BakjX3Q@mail.gmail.com>
        <20170518112720.GE2239@makrotopia.org>
        <CAKR_QVK6RvNvH327RCHbTv=6b9P=a5-pnu4xpKWh7aeJ8sOM3w@mail.gmail.com>
        <20170518121210.GF2239@makrotopia.org>
        <CAKR_QVLdiBx+hiUde6_uQC0dE5VHFxWz06dbRgKk6Eja8gg-tQ@mail.gmail.com>
Date: Thu, 18 May 2017 15:37:59 +0300
In-Reply-To: <CAKR_QVLdiBx+hiUde6_uQC0dE5VHFxWz06dbRgKk6Eja8gg-tQ@mail.gmail.com>
        (Tom Psyborg's message of "Thu, 18 May 2017 14:28:42 +0200")
Message-ID: <87zieawdaw.fsf@kamboji.qca.qualcomm.com> (sfid-20170518_143813_438827_86B7E2B4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tom Psyborg <pozega.tomislav@gmail.com> writes:

> On 18 May 2017 at 14:12, Daniel Golle <daniel@makrotopia.org> wrote:
>
>     Note that your mailer program destroyed the white-space formatting
>     of
>     the patch which I had to fix manually as a consequence of that
>     (tabs
>     were replaced by spaces, hence the patch didn't apply). Try to
>     setup
>     git-send-email using SMTP directly in order to avoid that in
>     future.
>     
>     Cheers
>
> I had same issues when tried sending to openwrt list, what i notice
> is, altough it is HTML patch i can copy it from my browser gmail into
> gedit without whitespace damaging. If i try Show original it shows up
> as whitespace damaged. If using evolution client to send patch it is
> other way round: shows up as damaged in gmail, but fine when click
> Show Original. i will try reinstalling evolution later.

Trying to use evolution or gmail web interface is waste of time, both
yours and us. Like Daniel said, switch to git send-email and you can say
goodbye to all formatting problmes.

-- 
Kalle Valo
