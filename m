Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:47310 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751329AbeDFIKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 04:10:45 -0400
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        ath10k@lists.infradead.org
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
 <871sftemru.fsf@kamboji.qca.qualcomm.com>
 <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
 <de9c007f-26e3-a511-e944-91e90aac7787@dd-wrt.com>
 <87h8oosqpg.fsf@codeaurora.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <0d1827fa-497d-7cf2-5372-74c2d1f459b2@dd-wrt.com> (sfid-20180406_101051_631443_3D6D62CE)
Date: Fri, 6 Apr 2018 10:10:42 +0200
MIME-Version: 1.0
In-Reply-To: <87h8oosqpg.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.04.2018 um 10:07 schrieb Kalle Valo:
> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> i have some comments about your check warnings.
>> some of them are bogus. for instance they advise to use "unsigned int"
>> instead of "unsigned". this might be better, but
>> the original kernel header uses "unsigned" as api definition. so i
>> decided to use the same declarations here.
> Sure, but using "unsigned int" won't create any harm either.
>
>> for the rest like whitespaces i will make a new version and remove them
> You missed my comment in my earlier mail that I'll send the next
> version. I have already fixed all the warnings so let me submit it. I'll
> do also some other changes.

oh okay. thank you. then forget all the rest. i will take care of these 
issues with the next patch i submit

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
