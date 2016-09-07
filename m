Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44778 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbcIGLjL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 07:39:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        =?utf-8?B?16nXqNeZINep?= =?utf-8?B?16jXldef?=
        <sarasharon1@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Nicholas Mc Guire <hofrat@osadl.org>, xypron.glpk@gmx.de,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        "johannes.berg\@intel.com" <johannes.berg@intel.com>
Subject: Re: [PATCH] rsi: code clean-up
References: <259efb66-b577-b6c1-a6af-2b27f8bbc1a4@redpinesignals.com>
        <CAGRGNgVyybFSqNLvtvXn-OL4dSXCpbYG2xR+cepayEQ6zPowSg@mail.gmail.com>
Date: Wed, 07 Sep 2016 14:38:18 +0300
In-Reply-To: <CAGRGNgVyybFSqNLvtvXn-OL4dSXCpbYG2xR+cepayEQ6zPowSg@mail.gmail.com>
        (Julian Calaby's message of "Wed, 7 Sep 2016 21:23:56 +1000")
Message-ID: <87vay8vt1x.fsf@kamboji.qca.qualcomm.com> (sfid-20160907_133914_582498_5B9F9481)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

> Hi,
>
> On Wed, Sep 7, 2016 at 8:26 PM, Prameela Rani Garnepudi
> <prameela.garnepudi@redpinesignals.com> wrote:
>>  From 0c3da95dfac07df5dffb5e00bcd8a38f2f8491c9 Mon Sep 17 00:00:00 2001
>> From: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
>> Date: Wed, 7 Sep 2016 15:28:43 +0530
>> Subject: [PATCH] rsi: code clean-up
>
> Describe what the changes are achieving.
>
> You're also still sending this as a HTML email, there are instructions
> on how to configure your email client to send plain text emails here:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/email-clients.txt
>
> Because you're sending multi-part HTML emails, your emails are being
> rejected by the mailing list.

I recommend to try to use git-send-email to submit patches, it makes
life so much more easier:

https://www.kernel.org/pub/software/scm/git/docs/git-send-email.html

-- 
Kalle Valo
