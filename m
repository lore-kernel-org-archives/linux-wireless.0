Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48220 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab1EEP0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 11:26:23 -0400
Received: by qwk3 with SMTP id 3so1501839qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 08:26:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimW+UGSt94fEKj976XUNnM=Vq-1AA@mail.gmail.com>
References: <BANLkTikui4mKvDjPfOw9CAXh5_oyR59xYQ@mail.gmail.com>
	<BANLkTimW+UGSt94fEKj976XUNnM=Vq-1AA@mail.gmail.com>
Date: Thu, 5 May 2011 17:26:22 +0200
Message-ID: <BANLkTimD5i4oCTT=bc0LRgDHcpXzjnN=Gw@mail.gmail.com> (sfid-20110505_172636_654993_3B901A02)
Subject: Re: [ath9k-devel] virtual CS / NAV
From: =?ISO-8859-1?Q?Manuel_S=E1ez?= <manuelsaezr@gmail.com>
To: Sagar Bijwe <sag.bijwe@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for your answer!

Do you know if it takes into account the CFPDurRemaining field of the
CF element? Otherwise, is it possible to change the
NAV value from software? (maybe through the AR_NAV register??) I was
playind around with this register right now :P.

Regards!



2011/5/5 Sagar Bijwe <sag.bijwe@gmail.com>:
> The virtual carrier sense is not implemented in software. It is handled by
> hw. There are flags to enable or disable NAV.
> -Sagar
>
> On Thu, May 5, 2011 at 6:55 PM, Manuel Sáez <manuelsaezr@gmail.com> wrote:
>>
>> Hi all,
>>
>> I am trying to find out if the "virtual carrier sense" is implemented
>> in the ath9k or mac80211 and where/how is it done. I would like to
>> know if the NAV is managed in software or hardware or maybe is not
>> being used at all. Does anybody have an idea of how it works?
>>
>> Any help would be great!
>>
>> Thank you!
>> Manolo
>> _______________________________________________
>> ath9k-devel mailing list
>> ath9k-devel@lists.ath9k.org
>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
>
