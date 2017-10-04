Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:57727 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751914AbdJDLdt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 07:33:49 -0400
Subject: Re: QCA988x and kernel 4.13
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>
Cc: svp <s.pooheer@gmail.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <c6294832-ff1e-595c-da8b-dac59b12a976@gmail.com>
 <7549b77b-3619-f8a5-48d6-eb7e330ba80e@dd-wrt.com>
 <48aebea8-9231-b41e-cbaa-d592d8540c53@candelatech.com>
 <87d163xpoe.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <2e7bafee-d3a5-41a7-de3e-7615f3c156bc@dd-wrt.com> (sfid-20171004_133432_740682_40606465)
Date: Wed, 4 Oct 2017 13:33:44 +0200
MIME-Version: 1.0
In-Reply-To: <87d163xpoe.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 04.10.2017 um 10:50 schrieb Kalle Valo:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 10/01/2017 07:06 AM, Sebastian Gottschall wrote:
>>> you have to update to the latest mac80211 code. there is a well
>>> known bug in mac80211 which causes a deadlock with ath10k
>> Do you have a pointer to the patch that fixes this?  I'd like to check if it has
>> made it into 4.13 stable yet...
> I think it's this one:
>
> mac80211: fix deadlock in driver-managed RX BA session start
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bde59c475e0883e4c4294bcd9b9c7e08ae18c828
>
> Adding linux-wireless so that someone can correct me in case I'm wrong.
i believe thats the correct one
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
