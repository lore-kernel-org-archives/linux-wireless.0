Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65425 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3HSFYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 01:24:15 -0400
Received: by mail-bk0-f49.google.com with SMTP id r7so1224361bkg.36
        for <linux-wireless@vger.kernel.org>; Sun, 18 Aug 2013 22:24:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878v0314nn.fsf@kamboji.qca.qualcomm.com>
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
	<1376036014-29707-4-git-send-email-michal.kazior@tieto.com>
	<878v0314nn.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 19 Aug 2013 07:24:13 +0200
Message-ID: <CA+BoTQmpcm65-5WDkih3oi-+MHDAy7gCzUrmmPzgmgCrVAKj8A@mail.gmail.com> (sfid-20130819_072424_704607_4D23464D)
Subject: Re: [PATCH 3/3] ath10k: add support for HTT 3.0
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 August 2013 15:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> New firmware comes with new HTT protocol version.
>> In 3.0 the separate mgmt tx command has been
>> removed. All traffic is to be pushed through data
>> tx (tx_frm) command with a twist - FW seems to not
>> be able (yet?) to access tx fragment table so for
>> manamgement frames frame pointer is passed
>> directly.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Because I dropped patch 1 this patch had conflicts. I tried to be extra
> careful, but please double check my conflict resolution.

Looks good, thanks!


Pozdrawiam / Best regards,
Michał Kazior.
