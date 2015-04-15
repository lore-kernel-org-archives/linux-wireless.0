Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:42563 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbbDOMA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 08:00:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: support new FCC DFS Radar Type 1
References: <1427305036-20326-1-git-send-email-poh@qca.qualcomm.com>
Date: Wed, 15 Apr 2015 15:00:45 +0300
In-Reply-To: <1427305036-20326-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Wed, 25 Mar 2015 10:37:16 -0700")
Message-ID: <87sic17g9e.fsf@kamboji.qca.qualcomm.com> (sfid-20150415_140108_782974_D93B7888)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Add support for new FCC DFS rules released on August 14, 2014.
> FCC has added a new radar type named Radar Type 1 and original
> Radar Type 1 is renamed to Radar Type 0 in consequence.
>
> During the certificate test, Type 1 PRI values are randomly selected
> within the range of 518 and 3066 and we divide it to 3 groups based on
> practical test result data collected for more than a year.
>
> For about Radar type ID, it does nothing to functionalities.
> In other words, even if we re-order the IDs, DFS detection will
> work as well, but we give the ID with matching to FCC doc.
>
> By adding this support, the drivers using this DFS function are
> able to support both of old and new FCC DFS rules simultaneously
> without any other changes.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
