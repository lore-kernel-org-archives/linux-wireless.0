Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:33193 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaAJMgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 07:36:31 -0500
Received: by mail-bk0-f51.google.com with SMTP id 6so1568985bkj.10
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jan 2014 04:36:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d2k09lwp.fsf@kamboji.qca.qualcomm.com>
References: <1389345563-3445-1-git-send-email-michal.kazior@tieto.com>
	<87d2k09lwp.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 10 Jan 2014 13:36:30 +0100
Message-ID: <CA+BoTQkpKeLKoYD-TRKVJON2fLmakrX-9Osy07FhYW5BhfAi9g@mail.gmail.com> (sfid-20140110_133635_489486_6B741AC4)
Subject: Re: [PATCH] ath10k: add support for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 January 2014 11:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This patch implements Channel Switch Announcement
>> for AP mode. This allows for a smooth channel
>> switch for connected stations that support CSA
>> when radar is detected.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> I had few conflicts while applying to ath-next-test (the branch for
> pending patches). Please double check my changes:
>
> https://github.com/kvalo/ath/commit/c7bb77f4bf9986e6be4b522ba1e01cd78ebb66af

It looks good, thanks.


Michał
