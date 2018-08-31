Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f171.google.com ([209.85.208.171]:41786 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbeHaRw3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 13:52:29 -0400
Subject: Re: [PATCH 10/23] wireless: remove unnecessary unlikely()
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Igor Stoppa <igor.stoppa@huawei.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-wireless@vger.kernel.org
References: <20180830223429.30051-1-igor.stoppa@huawei.com>
 <20180830223429.30051-11-igor.stoppa@huawei.com>
 <87va7qdfry.fsf@kamboji.qca.qualcomm.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <814defe0-72ab-049b-97cb-f295f4964895@gmail.com> (sfid-20180831_154527_806123_67EADF08)
Date: Fri, 31 Aug 2018 16:44:52 +0300
MIME-Version: 1.0
In-Reply-To: <87va7qdfry.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 31/08/18 12:52, Kalle Valo wrote:
> + linux-wireless

> IMHO you could fold patches 10, 11 and 12 into one to avoid having three
> patches with duplicate titles. Or alternatively use proper driver
> prefixes like "ath10k:", "b43:" and so on.

I was wondering if it would be ok to fold them, but it's easier to fold 
than to split, so I started with 3

> But how do you want these to be applied? For the wireless patches you
> didn't Cc linux-wireless so our patchwork won't see them and hence I
> can't take them. So if you want me to take these, please resend and
> include linux-wireless.


ok, I was hoping to avoid joining the ml but it's done
I had patches for about 20 different trees, so I decided to first see if 
the patches could be taken in right away.
In at least one case (pinctrl) I got lucky :-)

--
thanks, igor
