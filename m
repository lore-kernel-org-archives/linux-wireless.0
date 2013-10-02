Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39209 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3JBNAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 09:00:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix scheduling while atomic bug on config
References: <1380707467-30387-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQnQVE_YUrrtfFCeQSj4tmccbA9cG_ZMdHisx4C-mJfqkg@mail.gmail.com>
Date: Wed, 2 Oct 2013 16:00:05 +0300
In-Reply-To: <CA+BoTQnQVE_YUrrtfFCeQSj4tmccbA9cG_ZMdHisx4C-mJfqkg@mail.gmail.com>
	(Michal Kazior's message of "Wed, 2 Oct 2013 13:18:12 +0200")
Message-ID: <87pprn25gq.fsf@kamboji.qca.qualcomm.com> (sfid-20131002_150039_824650_324FF5C6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 2 October 2013 11:51, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Recent WMI/HTC changes introduces this bug because
>> now WMI commands can sleep.
>>
>> Use appropriate interface iteration function.
>>
>> Reported-By: Kalle Valo <kvalo@qca.qualcomm.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Self NACK.
>
> I've posted this too soon. This patch can lead to deadlocks on
> iflist_mtx in some cases.

Ok, thanks for letting me know. I'll drop the patch from my queue.

-- 
Kalle Valo
