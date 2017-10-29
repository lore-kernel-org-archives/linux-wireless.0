Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wp227.webpack.hosteurope.de ([80.237.132.234]:52112 "EHLO
        wp227.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751282AbdJ2KVh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 06:21:37 -0400
Subject: Re: ath10k-regression due to "ath10k: fix napi_poll budget overflow"
 c9353bf483d3
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
References: <5a4860eb-3734-7587-d81f-9c3de6ff11c8@leemhuis.info>
 <46f918c5-b07d-e397-2f3d-8136c7c1a8f3@qti.qualcomm.com>
 <fa6e3ee2-91b5-a54b-afe3-87f30aac7a48@leemhuis.info>
 <877evh53p8.fsf_-_@kamboji.qca.qualcomm.com>
 <72e73df5-c261-cb1a-7fba-b1a3a9019fea@qti.qualcomm.com>
 <87po964cvg.fsf@kamboji.qca.qualcomm.com>
From: Thorsten Leemhuis <linux@leemhuis.info>
Message-ID: <188f0cdd-d379-10f6-04e6-92f27e403e00@leemhuis.info> (sfid-20171029_112144_071815_81C48D08)
Date: Sun, 29 Oct 2017 11:21:33 +0100
MIME-Version: 1.0
In-Reply-To: <87po964cvg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lo! On 29.10.2017 08:44, Kalle Valo wrote:
> Ryan Hsu <ryanhsu@qti.qualcomm.com> writes:
>> On 10/27/2017 02:40 AM, Kalle Valo wrote:
>>
>>> + linux-wireless
>>> Sorry, I have not been able to follow this discussion very closely but
>>> was the conclusion? Should we should revert c9353bf483d3 for 4.14 or
>>> what? I should still have time to do that, but not much.
>> Kalle, I don't think I have enough time to look into the issue, since
>> original change is to avoid the warning, but now is having regression.
>> Let's try to revert c9353bf483d3 for 4.14, and I'll look into this later.
> 
> Great, thanks Ryan.
> I now submitted the revert and I'll try to get it to 4.14:
> https://patchwork.kernel.org/patch/10031233/

Sorry, I'm a bit behind with my mail after lot's of work@work and some
travelling right after that.

Ryan, Kalle: Thx for taking care of this. If you sooner or later want me
to test patches that try to solve the warning without causing this
regression simply drop me a line. Ciao, Thorsten
