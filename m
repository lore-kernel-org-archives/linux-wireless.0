Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:39631 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbBJLHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 06:07:43 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix wmm params per vdev
References: <CADnKcViRWR1Ex-=QGzROQGYKNcZLMSu+mLDJ8-KhUuf=acDXdQ@mail.gmail.com>
Date: Tue, 10 Feb 2015 13:07:31 +0200
In-Reply-To: <CADnKcViRWR1Ex-=QGzROQGYKNcZLMSu+mLDJ8-KhUuf=acDXdQ@mail.gmail.com>
	(Marek Puzyniak's message of "Tue, 10 Feb 2015 09:27:13 +0100")
Message-ID: <87egpynhxo.fsf@kamboji.qca.qualcomm.com> (sfid-20150210_120746_623426_CF095812)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> On 6 February 2015 at 14:41, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
>> During wmm tests changing wmm parameters did not change anything.
>> This was because of mismatch in WMM params per vdev command.
>> WMM params per vdev uses different command structure than wmm params
>> per pdev command. Also txop for per vdev settings has the
>> same units as provided by mac80211.
>>
>> Patch concerns qca6174.
>>
>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>
> Kalle,
>
> Please do not merge this patch yet. I need to clarify some side effects.
> I will inform you about next steps.

Ok, I have dropped the patch. Please resend if it's ok to apply.

-- 
Kalle Valo
