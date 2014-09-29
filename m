Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55495 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI2HQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 03:16:15 -0400
Received: by mail-wg0-f43.google.com with SMTP id a1so1199120wgh.2
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2014 00:16:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8761g94hm4.fsf@kamboji.qca.qualcomm.com>
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
	<1411641230-18785-5-git-send-email-michal.kazior@tieto.com>
	<8761g94hm4.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 29 Sep 2014 09:16:14 +0200
Message-ID: <CA+BoTQmC7vec3OW8ZbCvkx761cMtUTT6f+UAVp7dMXj2hNRKUA@mail.gmail.com> (sfid-20140929_091624_895524_C6E8E995)
Subject: Re: [PATCH 4/4] ath10k: fix fw stats processing
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 September 2014 10:01, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> If stat data exceeds wmi-htc buffer limits
>> firmware splits it into many wmi stats update
>> events which are delivered in a ping-pong fashion
>> triggered by wmi stats request command.
>>
>> Since there's only an implicit start-of-data and
>> no end-of-data indications the driver has to
>> perform some trickery to get complete stat data.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> I folded the patch below in ath-next-next. Please check:
>
> https://github.com/kvalo/ath/commit/7071112c5ddaff761cd7d9bb3110c3f3d2f83bb8
[...]

I think you meant:

  https://github.com/kvalo/ath/commit/5122a60f4fbf5a38e70a14578858b39058ee367a

It looks good. Thanks!


Michał
