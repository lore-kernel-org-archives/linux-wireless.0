Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46559 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1JCLn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:43:26 -0400
Date: Mon, 3 Oct 2011 17:11:35 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: Avoid processing failed rx packets
Message-ID: <20111003114134.GC24335@vasanth-laptop> (sfid-20111003_134329_991112_37D727EE)
References: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com> <1317308476-16204-3-git-send-email-vthiagar@qca.qualcomm.com> <4E8999E9.4090904@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E8999E9.4090904@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 03, 2011 at 02:18:01PM +0300, Kalle Valo wrote:
> On 09/29/2011 06:01 PM, Vasanthakumar Thiagarajan wrote:
> > It is not necessary to process an htc_packet which is allocated for rx
> > but failed in sdio rx.
> 
> Same question here: does it fix a visible bug or is it more like a
> theoretical issue?
> 
> I would prefer that fixes would also state the impact of the bug: is it
> a theoretical issue, a random bug which almost nobody sees or really bad
> bug visible almost everywhere? That way it's easier to decide which
> trees it should be sent.

Ok, I can add this to commit log. I'll resend everything with V2.

Vasanth
