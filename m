Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33030 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaGVIOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 04:14:06 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so7531148wgg.12
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 01:14:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d2cyy5kh.fsf@kamboji.qca.qualcomm.com>
References: <1405516873-26411-1-git-send-email-michal.kazior@tieto.com>
	<87d2cyy5kh.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 22 Jul 2014 10:14:03 +0200
Message-ID: <CA+BoTQ=qXyEqo0ZpWcJVGjttGj0SSFo3Cj18qNZxT4xHhzSwgQ@mail.gmail.com> (sfid-20140722_101414_271857_5F77DCC1)
Subject: Re: [RFC/RFT 1/2] ath10k: fix monitor start/stop sequences
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Vu Hai NGUYEN <vh.nguyen@actiasodielec.fr>,
	Sven Schnelle <svens@stackframe.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 July 2014 19:39, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Fix some cases where monitor start failure left
>> the driver in a confused state.
>>
>> This also makes the monitor code simpler.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> From a quick review looks good to me. Are you planning to submit this as
> a proper patch at some point?

I've been waiting for feedback in case this breaks someone's setup/use
cases (it shouldn't but hey). No one has complained so I guess I'll be
posting this as a PATCH soon.


Michał
