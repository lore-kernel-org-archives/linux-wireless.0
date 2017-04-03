Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46638 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdDCLwy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 07:52:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>
Subject: Re: [PATCH 1/5] brcmfmac: wrap brcmf_fws_init into bcdc layer
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
        <1490697808-5538-2-git-send-email-arend.vanspriel@broadcom.com>
        <a1ced78f-6769-be2d-f2a6-cb3ae4d8a0c2@gmail.com>
        <c456c480-860a-6a92-8b5c-f3803b9adf6d@broadcom.com>
Date: Mon, 03 Apr 2017 14:52:49 +0300
In-Reply-To: <c456c480-860a-6a92-8b5c-f3803b9adf6d@broadcom.com> (Arend Van
        Spriel's message of "Thu, 30 Mar 2017 10:08:04 +0200")
Message-ID: <87vaqln1wu.fsf@kamboji.qca.qualcomm.com> (sfid-20170403_135257_748695_0C53B992)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 29-3-2017 13:18, Rafa=C5=82 Mi=C5=82ecki wrote:
>> On 03/28/2017 12:43 PM, Arend van Spriel wrote:
>>> From: Franky Lin <franky.lin@broadcom.com>
>>>
>>> Create a new protocol layer interface brcmf_proto_init_cb for protocol
>>> layer to finish initialzation after core module components(fweh and
>>> etc.) are initialized.
>>>
>>> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
>>> Change-Id: I560d2478a7c09766cf07b20d74b31dff5ca6ac7b
>>> Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/8156
>>=20
>> These 2 lines are rather useless.
>
> Sorry. Our Gerrit server adds these and I make an effort to remove this
> before submitting, but every now and then a few slip through.
>
>>> Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
>>=20
>> Please use full names only.
>
> Sure thing. This is actually Jenkins account we use for building and
> smoketesting the driver.

I'll remove these from patches 1-4 during commit. (patch 5 seems to be
ok)

--=20
Kalle Valo
