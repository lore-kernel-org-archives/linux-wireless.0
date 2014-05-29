Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57769 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaE2Hs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 03:48:56 -0400
Received: by mail-vc0-f179.google.com with SMTP id im17so13634301vcb.38
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 00:48:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com>
References: <CALCETrU=8+tnptdfva4p27nA-5=E31DwXagoLqUxYcLtEKrB+w@mail.gmail.com>
Date: Thu, 29 May 2014 09:48:55 +0200
Message-ID: <CA+BoTQmUyvTr+ga81EacbMkE4UVtMBP2PfBs_vH-PF4OvHuZQg@mail.gmail.com> (sfid-20140529_094900_621417_7ED754E8)
Subject: Re: compat-wireless-2014-05-22 breaks ath10k in an Archer C7 v2
From: Michal Kazior <michal.kazior@tieto.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ath10k@lists.infradead.org

On 28 May 2014 20:35, Andy Lutomirski <luto@amacapital.net> wrote:
> It dies with 'otp calibration failed: 2'.
>
> Some older version of the driver seemed to work fine.

ath10k did not verify otp result before so it could load successfully
despite errors.

Someone raised this problem yesterday on IRC. I'm not really sure how
we should deal with this properly.


Michał
