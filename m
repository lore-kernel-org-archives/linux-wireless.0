Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35562 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbbFGLwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 07:52:03 -0400
Received: by wiga1 with SMTP id a1so59301861wig.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 04:52:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87k2vhnh43.fsf@kamboji.qca.qualcomm.com>
References: <1433588234-27248-1-git-send-email-ap420073@gmail.com>
	<87k2vhnh43.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 7 Jun 2015 20:52:00 +0900
Message-ID: <CAMArcTXitpjP_f6o+O63n6ugysCfDktdOQF20-qeAToqZ4ycHg@mail.gmail.com> (sfid-20150607_135431_796914_3DFF56B7)
Subject: Re: [PATCH V2 1/3] rtlwifi: rtl8192cu: remove duplicated routine in _rtl92c_phy_rf6052_config_parafile
From: Taehee Yoo <ap420073@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-06 21:42 GMT+09:00 Kalle Valo <kvalo@codeaurora.org>:
> Taehee Yoo <ap420073@gmail.com> writes:
>
>> in the _rtl92c_phy_rf6052_config_parafile(), cases
>> RF90_PATH_A and RF90_PATH_B call the same routine.
>> so i remove one of these routine. also the return
>> routine is duplicated. so i remove it.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> Please resend the whole series (ie. all three patches), not just the
> patch which has changed.
>
> --
> Kalle Valo

Thank you for your feedback!
I will resend the two patches.
