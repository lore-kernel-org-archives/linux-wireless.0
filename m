Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35602 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966AbaE2Rwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 13:52:53 -0400
Received: by mail-vc0-f182.google.com with SMTP id id10so796108vcb.13
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 10:52:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com>
References: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com>
 <CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 May 2014 10:52:32 -0700
Message-ID: <CALCETrUDWvXddiACacre3erhwrKCjO53iHVKmPrApTi65Z5yBA@mail.gmail.com> (sfid-20140529_195258_544494_1E306A01)
Subject: Re: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2014 at 12:48 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> +ath10k@lists.infradead.org
>
> On 28 May 2014 20:35, Andy Lutomirski <luto@amacapital.net> wrote:
>> It dies with 'otp calibration failed: 2'.
>>
>> Some older version of the driver seemed to work fine.
>
> ath10k did not verify otp result before so it could load successfully
> despite errors.
>
> Someone raised this problem yesterday on IRC. I'm not really sure how
> we should deal with this properly.
>

Ideally, someone from Atheros could figure out what the error is.
Barring that, the card seems to work okay without otp (I don't even
know what otp is), so just warning and continuing to load might be
better than bailing.

--Andy
