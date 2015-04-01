Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63373 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbbDARND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 13:13:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: mac: match wait_for_completion_timeout return type
References: <1426271886-20562-1-git-send-email-hofrat@osadl.org>
Date: Wed, 1 Apr 2015 20:12:53 +0300
In-Reply-To: <1426271886-20562-1-git-send-email-hofrat@osadl.org> (Nicholas Mc
	Guire's message of "Fri, 13 Mar 2015 14:38:06 -0400")
Message-ID: <87ego3zsa2.fsf@kamboji.qca.qualcomm.com> (sfid-20150401_191327_832434_18D140DF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> writes:

> Return type of wait_for_completion_timeout is unsigned long not int.
> An appropriately named unsigned long is added, respectively 'ret'
> renamed, and the assignments fixed up.
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Thanks, applied.

-- 
Kalle Valo
