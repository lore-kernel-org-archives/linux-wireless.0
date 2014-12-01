Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60488 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaLAIfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 03:35:19 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so13520726wgh.16
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 00:35:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8761dvreui.fsf@kamboji.qca.qualcomm.com>
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
	<1417418266-21974-1-git-send-email-michal.kazior@tieto.com>
	<8761dvreui.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 1 Dec 2014 09:35:18 +0100
Message-ID: <CA+BoTQko3rFTsZD1M4OzBRzd-oQAauMr6fPVjzvgw17n1H2uag@mail.gmail.com> (sfid-20141201_093523_159517_3FB1B8A2)
Subject: Re: [PATCH v2 1/3] ath10k: create a chip revision whielist
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2014 at 08:47, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This will make it easier to extend and maintain
>> list of supported hardware.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> I fixed a typo: s/whielist/whitelist/

Oops. Thanks!


>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -479,7 +479,6 @@ struct ath10k {
>>               u32 id;
>>               const char *name;
>>               u32 patch_load_addr;
>> -
>>               struct ath10k_hw_params_fw {
>>                       const char *dir;
>>                       const char *fw;
>
> I removed this unnecessary change:
>
> https://github.com/kvalo/ath/commit/bfa7b7948acaf7063cf4d664393b7f7a1c53b2e4
>
> Because of my change there was also a simple conflict in patch 3:
>
> https://github.com/kvalo/ath/commit/3487683c94495b6e0bbb1f3b19b3987b4ca2ff1f

Ah, my original intention was to eventually remove the blank line
along with these patches but whatever. Looks good nonetheless, thanks!


Michał
