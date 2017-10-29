Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:45965 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdJ2Hoa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 03:44:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qti.qualcomm.com>
CC: Thorsten Leemhuis <linux@leemhuis.info>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: ath10k-regression due to "ath10k: fix napi_poll budget overflow"
 c9353bf483d3
Date: Sun, 29 Oct 2017 07:44:20 +0000
Message-ID: <87po964cvg.fsf@kamboji.qca.qualcomm.com> (sfid-20171029_084439_939103_4BB6607F)
References: <5a4860eb-3734-7587-d81f-9c3de6ff11c8@leemhuis.info>
        <46f918c5-b07d-e397-2f3d-8136c7c1a8f3@qti.qualcomm.com>
        <fa6e3ee2-91b5-a54b-afe3-87f30aac7a48@leemhuis.info>
        <877evh53p8.fsf_-_@kamboji.qca.qualcomm.com>
        <72e73df5-c261-cb1a-7fba-b1a3a9019fea@qti.qualcomm.com>
In-Reply-To: <72e73df5-c261-cb1a-7fba-b1a3a9019fea@qti.qualcomm.com> (Ryan
        Hsu's message of "Fri, 27 Oct 2017 19:01:32 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@qti.qualcomm.com> writes:

> On 10/27/2017 02:40 AM, Kalle Valo wrote:
>
>> + linux-wireless
>>
>> Sorry, I have not been able to follow this discussion very closely but
>> was the conclusion? Should we should revert c9353bf483d3 for 4.14 or
>> what? I should still have time to do that, but not much.
>
> Kalle, I don't think I have enough time to look into the issue, since
> original change is to avoid the warning, but now is having regression.
> Let's try to revert c9353bf483d3 for 4.14, and I'll look into this later.

Great, thanks Ryan.

I now submitted the revert and I'll try to get it to 4.14:

https://patchwork.kernel.org/patch/10031233/

--=20
Kalle Valo=
