Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14681 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbCMQU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 12:20:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/3 RFC] ath10k: wmi: match wait_for_completion_timeout return type
References: <1426175362-8640-1-git-send-email-hofrat@osadl.org>
Date: Fri, 13 Mar 2015 18:20:01 +0200
In-Reply-To: <1426175362-8640-1-git-send-email-hofrat@osadl.org> (Nicholas Mc
	Guire's message of "Thu, 12 Mar 2015 11:49:22 -0400")
Message-ID: <87bnjwrhse.fsf@kamboji.qca.qualcomm.com> (sfid-20150313_172101_164951_51F2B0E4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> writes:

> Return type of wait_for_completion_timeout is unsigned long not int.
> An appropriately named unsigned long is added and the assignments fixed up.
> Rather than returning 0 (timeout) or a more or less random remaining time
> (completion success) this return 0 or 1 which also resolves the type of the
> functions being int.
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Why does patch 2 in this patchset have RFC in the title but patches 1
and 3 not? That just makes me confused, I can't tell what you want me to
do with the patches. Normally I just drop all patches (or patchsets)
which have RFC, and that's what I'm going to do now.

To save everyone's time, when submitting something please state clearly
what's your intention.

-- 
Kalle Valo
