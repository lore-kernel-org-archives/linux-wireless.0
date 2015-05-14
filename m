Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48688 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbbENRFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 13:05:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: wmi: match wait_for_completion_timeout return type
References: <1431621821-8173-1-git-send-email-hofrat@osadl.org>
Date: Thu, 14 May 2015 20:05:37 +0300
In-Reply-To: <1431621821-8173-1-git-send-email-hofrat@osadl.org> (Nicholas Mc
	Guire's message of "Thu, 14 May 2015 18:43:41 +0200")
Message-ID: <87fv6zccny.fsf@kamboji.qca.qualcomm.com> (sfid-20150514_190609_448604_E3DCD41B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> writes:

> Patch is against 4.1-rc3 (localversion-next is -next-20150514)

BTW, this info should be under "---" line so that it doesn't get stored
to the actual commit log.

-- 
Kalle Valo
