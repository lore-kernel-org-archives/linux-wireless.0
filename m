Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50631 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbA0OGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:06:14 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<antonio@open-mesh.com>
Subject: Re: [PATCH 0/2] ath10k: fix 10.2 fw stats
References: <1421413928-7282-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 16:06:02 +0200
In-Reply-To: <1421413928-7282-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 16 Jan 2015 14:12:06 +0100")
Message-ID: <87y4oob9o5.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_150617_927274_9D2F4171)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> I've tested this briefly with main 636, 10.1.467,
> 10.2-00082-4 and 10.2.4.20. However I may have
> missed something so I'd be glad if someone can
> double-check me :-)
>
> Michal Kazior (2):
>   ath10k: split fw pdev stats parsing
>   ath10k: fix 10.2 fw stats parsing

Thanks, both patches applied.

-- 
Kalle Valo
