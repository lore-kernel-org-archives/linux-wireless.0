Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:60623 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaDHGHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 02:07:34 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so431742wes.18
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2014 23:07:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fvlpnt5x.fsf@kamboji.qca.qualcomm.com>
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-2-git-send-email-michal.kazior@tieto.com>
	<87fvlpnt5x.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 8 Apr 2014 08:07:32 +0200
Message-ID: <CA+BoTQnJ2Dg9O64=uvn7U=6Tadv6WwcRGOViHScuS3sQ8=OeMg@mail.gmail.com> (sfid-20140408_080813_790180_59EB00E4)
Subject: Re: [PATCH v2 1/2] ath10k: reorder functions
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 April 2014 15:52, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This is done to avoid forward declarations with
>> upcomming patches.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Like you said, I had a conflict with this patch. Can you double check my
> resolution, please:
>
> https://github.com/kvalo/ath/commit/0953accf20c325adde537a57c3e6a6a0f1ff04d7

Looks good.


Michał
