Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51142 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaCXIao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 04:30:44 -0400
Received: by mail-oa0-f49.google.com with SMTP id h16so5432986oag.36
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 01:30:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d2hc80qp.fsf@kamboji.qca.qualcomm.com>
References: <1395380076-4306-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmLfdkyN8yC8m-i_yXbhQ3UYVj1kPrdFmYSyLONCC=Kig@mail.gmail.com>
	<87d2hc80qp.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 24 Mar 2014 09:30:44 +0100
Message-ID: <CA+BoTQktUw+VhNfAWNJEECGjL9mTGPLTxBsrGOdzJtArjuC11A@mail.gmail.com> (sfid-20140324_093048_827745_DED6E9C5)
Subject: Re: [PATCH] ath10k: fix the peer mac address in getting stats
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2014 09:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:

[...]

>> Other than that the patch looks good.
>>
>> Reviewed-By: Michał Kazior <michal.kazior@tieto.com>
>
> Thanks, I added this to the patch.
>
> Let's just hope that the l with the extra line doesn't cause any charset
> problems :) BTW, what is the name of the character? Never seen that
> before.

http://www.fileformat.info/info/unicode/char/142/index.htm

I don't care much if you s/ł/l/. I already commit patches with an l.


Michał
