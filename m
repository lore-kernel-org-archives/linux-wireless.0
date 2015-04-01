Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16894 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbbDARQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 13:16:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: debug: match wait_for_completion_timeout return type
References: <1426325830-19740-1-git-send-email-hofrat@osadl.org>
Date: Wed, 1 Apr 2015 20:16:24 +0300
In-Reply-To: <1426325830-19740-1-git-send-email-hofrat@osadl.org> (Nicholas Mc
	Guire's message of "Sat, 14 Mar 2015 05:37:10 -0400")
Message-ID: <87619fzs47.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_191700_946381_5C6995A6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> writes:

> Return type of wait_for_completion_timeout is unsigned long not int.
> An appropriately named unsigned long is added and the assignments fixed up.
> Missing spaces 1*HZ -> 1 * HZ were also added along the way.
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Thanks, applied.

-- 
Kalle Valo
