Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63265 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab1JCLpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:45:23 -0400
Message-ID: <4E89A01B.2010709@qca.qualcomm.com> (sfid-20111003_134531_347490_ABBFA87C)
Date: Mon, 3 Oct 2011 14:44:27 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: Avoid processing failed rx packets
References: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com> <1317308476-16204-3-git-send-email-vthiagar@qca.qualcomm.com> <4E8999E9.4090904@qca.qualcomm.com> <20111003114134.GC24335@vasanth-laptop>
In-Reply-To: <20111003114134.GC24335@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2011 02:41 PM, Vasanthakumar Thiagarajan wrote:
> On Mon, Oct 03, 2011 at 02:18:01PM +0300, Kalle Valo wrote:
>> On 09/29/2011 06:01 PM, Vasanthakumar Thiagarajan wrote:
>>> It is not necessary to process an htc_packet which is allocated for rx
>>> but failed in sdio rx.
>>
>> Same question here: does it fix a visible bug or is it more like a
>> theoretical issue?
>>
>> I would prefer that fixes would also state the impact of the bug: is it
>> a theoretical issue, a random bug which almost nobody sees or really bad
>> bug visible almost everywhere? That way it's easier to decide which
>> trees it should be sent.
> 
> Ok, I can add this to commit log. I'll resend everything with V2.

Excellent, thanks a lot.

Kalle
