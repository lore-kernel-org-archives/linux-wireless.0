Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7246 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbbDARTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 13:19:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: core: match wait_for_completion_timeout return type
References: <1426325858-19808-1-git-send-email-hofrat@osadl.org>
Date: Wed, 1 Apr 2015 20:18:42 +0300
In-Reply-To: <1426325858-19808-1-git-send-email-hofrat@osadl.org> (Nicholas Mc
	Guire's message of "Sat, 14 Mar 2015 05:37:37 -0400")
Message-ID: <87wq1vydfw.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_191925_745486_8C5C8296)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> writes:

> Return type of wait_for_completion_timeout is unsigned long not int.
> An appropriately named unsigned long is added and the assignments fixed up.
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Thanks, applied.

-- 
Kalle Valo
