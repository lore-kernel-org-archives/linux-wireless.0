Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33948 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3IAGpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 02:45:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: remove un ar_pci->cacheline_sz field
References: <20130802075601.11114.11607.stgit@localhost6.localdomain6>
Date: Sun, 1 Sep 2013 09:44:49 +0300
In-Reply-To: <20130802075601.11114.11607.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Fri, 02 Aug 2013 10:56:01 +0300")
Message-ID: <87sixp6nxa.fsf@kamboji.qca.qualcomm.com> (sfid-20130901_084530_042252_A16E6C9A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> cacheline_sz is not used anywhere and can be removed.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

I had sent this patch a month ago, but forgot to apply it. It's applied
now (after fixing a simple conflict).

-- 
Kalle Valo
