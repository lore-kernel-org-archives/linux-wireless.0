Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63177 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1ISFjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 01:39:24 -0400
Received: by bkbzt4 with SMTP id zt4so5023033bkb.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 22:39:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E738BFE.7080201@qca.qualcomm.com>
References: <4E737241.2080301@qca.qualcomm.com>
	<CAD2nsn14EnEWyu2ifM6-5evQN4qGqe4Me7wsZ=xLPt+RBpJeWw@mail.gmail.com>
	<4E738BFE.7080201@qca.qualcomm.com>
Date: Mon, 19 Sep 2011 11:09:23 +0530
Message-ID: <CAD2nsn1oC2N5qL2eg8rMa6_2w49DTe_V2w-JGdrZ2jwj9b-Hzg@mail.gmail.com> (sfid-20110919_073928_145010_EEE8D1A6)
Subject: Re: ath9k_htc: "No free RX buffer" in monitor mode
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, viscous.liquid@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 16, 2011 at 11:18 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Hi Shafi,
>
> On 09/16/2011 07:09 PM, Mohammed Shafi wrote:
>> On Fri, Sep 16, 2011 at 9:28 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Hi,
>>>
>>> I was testing monitor mode with ath9k_htc and my laptop got slower. Then
>>> I noticed this:
>>>
>>> [ 9246.606150] ath: No free RX buffer
>>> [ 9246.606156] ath: No free RX buffer
>>> [ 9246.606582] ath: No free RX buffer
>>> [ 9246.606590] ath: No free RX buffer
>>>
>>> And I saw it quite a lot:
>>
>> we saw this some time back in AP mode occasionally and it never came
>> up for as in monitor mode. we need to fix this.
>> i will try to fix this.
>
> Thanks! I will run more tests with monitor mode next week and will let
> you know if I see it again.

Kalle thanks, now I could easily get this thing in monitor mode itself
in a busy channel (6, HT20).
will fix this soon.

issue can be found with latest compat-wireless/wireless-testing

>
> Kalle
>



-- 
shafi
