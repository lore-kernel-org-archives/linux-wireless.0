Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45134 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbdJDPNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 11:13:46 -0400
Subject: Re: QCA988x and kernel 4.13
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <c6294832-ff1e-595c-da8b-dac59b12a976@gmail.com>
 <7549b77b-3619-f8a5-48d6-eb7e330ba80e@dd-wrt.com>
 <48aebea8-9231-b41e-cbaa-d592d8540c53@candelatech.com>
 <87d163xpoe.fsf@kamboji.qca.qualcomm.com>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        svp <s.pooheer@gmail.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <78f5383d-0187-628e-cf56-de6234fdb9b0@candelatech.com> (sfid-20171004_171350_772632_A4D64E0B)
Date: Wed, 4 Oct 2017 08:13:43 -0700
MIME-Version: 1.0
In-Reply-To: <87d163xpoe.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/04/2017 01:50 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 10/01/2017 07:06 AM, Sebastian Gottschall wrote:
>>> you have to update to the latest mac80211 code. there is a well
>>> known bug in mac80211 which causes a deadlock with ath10k
>>
>> Do you have a pointer to the patch that fixes this?  I'd like to check if it has
>> made it into 4.13 stable yet...
>
> I think it's this one:
>
> mac80211: fix deadlock in driver-managed RX BA session start
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bde59c475e0883e4c4294bcd9b9c7e08ae18c828
>
> Adding linux-wireless so that someone can correct me in case I'm wrong.

That did seem to fix my problems...

Thanks,
ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
