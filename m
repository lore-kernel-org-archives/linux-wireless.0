Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759993AbcBYPDA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 10:03:00 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/28] rtl8xxxu: If fw running in RAM, reset the 8051 before trying to download a new one
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
	<1454524802-26763-4-git-send-email-Jes.Sorensen@redhat.com>
	<87a8mpf7wp.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 25 Feb 2016 10:02:59 -0500
In-Reply-To: <87a8mpf7wp.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Thu, 25 Feb 2016 11:36:54 +0200")
Message-ID: <wrfj7fhs3k9o.fsf@redhat.com> (sfid-20160225_160304_314975_D44D52AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> No empty commit logs, please. And this patch even has a too long title
> which really should be the actual commit log.
>
> I can take this now but in the future please write one.

It does, the $Subject is the commit log. But I'll try and break it down
on more lines if there is something to add.

Jes
