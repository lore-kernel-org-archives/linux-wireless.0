Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59685 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbdEPFbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 01:31:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michael Mera <dev@michaelmera.com>
CC: Marcin Rokicki <marcin.rokicki@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix out of bounds access to local buffer
Date: Tue, 16 May 2017 05:31:26 +0000
Message-ID: <87d1b9v044.fsf@qca.qualcomm.com> (sfid-20170516_073143_092817_BA7F8662)
References: <20170424053902.1644-1-dev@michaelmera.com>
        <CAN6Sofawy9BmFaVgNw=gt=9VwLqNFdCQ2fa3DApvJTVCJpjoqg@mail.gmail.com>
        <87inludzh6.fsf@michaelmera.com>
In-Reply-To: <87inludzh6.fsf@michaelmera.com> (Michael Mera's message of "Mon,
        24 Apr 2017 16:41:25 +0900")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Mera <dev@michaelmera.com> writes:

> Marcin Rokicki <marcin.rokicki@gmail.com> writes:
>> Please send again to ath10k@lists.infradead.org with cc
>> linux-wireless@vger.kernel.org
>>
>
> Sorry for the mistake. Resent as requested.
>
> Just for the record, I followed instructions at:
>   https://wireless.wiki.kernel.org/en/developers/documentation/submitting=
patches?s[]=3Dsubmit#who_to_address
>
> So, maybe this needs to be updated to reflect the ath10k case.

I added a link to the corresponding ath10k page. BTW, it's a wiki so
everyone are free to improve the instructions on their own.

--=20
Kalle Valo=
