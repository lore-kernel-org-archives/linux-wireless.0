Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55352 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbdFJQD4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 12:03:56 -0400
Message-ID: <593C17DA.7080603@candelatech.com> (sfid-20170610_180359_766892_A0107F6C)
Date: Sat, 10 Jun 2017 09:01:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: fengbin <arithdon@gmail.com>
CC: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Denis Kenzior <denkenz@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com> <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com> <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com> <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com> <1496993334.2424.1.camel@sipsolutions.net> <de7611e7-c34d-26e2-4083-b7e01b657426@candelatech.com> <1497038480.12088.6.camel@sipsolutions.net> <e617e9f9-0a83-cfef-9bb3-127a06ba33e0@candelatech.com> <CAFED-jnTNGU-VozW1kLxzHk+Uq3JfR2kTfu-J8gTbrHebzX_2w@mail.gmail.com> <f5bb406e-0c1d-393c-54f1-97847017a473@candelatech.com> <CADP2NhbXgHWo+BWhrKQndu5X7fzd2J9teqf-o6fSWwDMv8X5Hw@mail.gmail.com>
In-Reply-To: <CADP2NhbXgHWo+BWhrKQndu5X7fzd2J9teqf-o6fSWwDMv8X5Hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/09/2017 04:51 PM, fengbin wrote:
> seems your firmware doesn't support HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT?
> Otherwise , it should work perfectly because Key messages are marked as no hw encryption.

Well, it could be my bug.....but unless you have access to ath10k firmware, then
I can't explain further what is the particular issue.  If you do have access,
then I can give you some hints to follow the code path in question.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
