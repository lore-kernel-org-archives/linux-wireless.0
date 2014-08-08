Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24863 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbaHHJjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 05:39:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [RFC 0/3] ath10k: ce fixes 2014-08-08
References: <1407489735-28091-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 8 Aug 2014 12:38:54 +0300
In-Reply-To: <1407489735-28091-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 8 Aug 2014 11:22:12 +0200")
Message-ID: <87ppgbz5g1.fsf@kamboji.qca.qualcomm.com> (sfid-20140808_113907_793371_A3068177)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This removes implicit endianess in some places.
> I'd love to get rid of it from
> ath10k_pci_diag_access* as well but let's fix
> ath10k_pci_diag_mem_* first.
>
> @Kalle, @Ben: As far as I understand this
> conflicts with fw dumping you work on so I'm
> tentatively posting this as an RFC first.

Yeah, and I have done some ath10k_pci_diag_ changes in Ben's patches. It
would be easier if you could rebase your patches on top of ben's
firmware crash patches, which I should be able to submit today for first
review.

-- 
Kalle Valo
