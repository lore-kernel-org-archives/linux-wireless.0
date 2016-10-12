Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56009 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755378AbcJLOjj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 10:39:39 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hofrat@osadl.org" <hofrat@osadl.org>,
        "xypron.glpk@gmx.de" <xypron.glpk@gmx.de>,
        "prameela.garnepudi@redpinesignals.com"
        <prameela.garnepudi@redpinesignals.com>
Subject: Re: [PATCH] rsi: update in vap_capabilities frame to device
Date: Wed, 12 Oct 2016 14:39:33 +0000
Message-ID: <87bmypeimz.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_163943_516185_F2C23D7A)
References: <1474885981-6810-1-git-send-email-prameela.j04cs@gmail.com>
        <87k2ddej46.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k2ddej46.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Wed, 12 Oct 2016 17:29:13 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:
>
>> added vap status(add/delete) field in vap capabilities frame to device
>> added sending vap capabilites frame(with vap status 'delete') in remove =
interface
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> Why? How is this better now? I'm sure there is a good reason why you add
> this but we don't know as the commit tells nothing we don't already know
> just from looking at the patch.
>
> The most important part of commit log is to answer the question "Why?",
> not "What?".

Oh, and USE capitalisation, punctuation and so on in the commit log. It
will be archived to git.

--=20
Kalle Valo=
