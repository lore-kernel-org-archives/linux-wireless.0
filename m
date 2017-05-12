Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60946 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932928AbdELJQp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 05:16:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Xie Qirong <cheerx1994@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: btcoex: replace init_timer with setup_timer
References: <20170512073555.12333-1-cheerx1994@gmail.com>
        <87tw4qqyh1.fsf@kamboji.qca.qualcomm.com>
        <c5e21126-23e6-8cef-d01b-dc225dab1982@broadcom.com>
        <87d1beqwtc.fsf@kamboji.qca.qualcomm.com>
        <036761ff-85a9-6042-57ed-ca3968550737@broadcom.com>
Date: Fri, 12 May 2017 12:16:38 +0300
In-Reply-To: <036761ff-85a9-6042-57ed-ca3968550737@broadcom.com> (Arend van
        Spriel's message of "Fri, 12 May 2017 11:10:36 +0200")
Message-ID: <878tm2qvt5.fsf@kamboji.qca.qualcomm.com> (sfid-20170512_111709_760941_2C675423)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

>>> This third version is the same as v1 on which I commented to put the
>>> coccinelle output in the commit message. So I would still keep v2 if
>>> nothing else changed in v3 apart from my Acked-by: tag.
>>
>> Ok, but I can easily take v3 (ie. this one) so that you get credit ;)
>
> If you add the coccinelle output in the commit message, ie. above the
> '---' that would be great. So for both you have to do additional stuff
> provided you find it useful to have the coccinelle output. :-p

Sure, I can add that. Thanks to my patchwork script it's actually pretty
easy to edit commit logs before it commits them. If only I had time to
implement a proper GTK interface for the script...

-- 
Kalle Valo
