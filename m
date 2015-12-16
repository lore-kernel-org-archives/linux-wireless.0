Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54438 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551AbbLPOjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:39:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Subject: Re: [PATCH 1/2] wil6210: fix kernel OOPS when stopping interface during Rx traffic
References: <1449926565-888-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1449926565-888-2-git-send-email-qca_merez@qca.qualcomm.com>
Date: Wed, 16 Dec 2015 16:39:29 +0200
In-Reply-To: <1449926565-888-2-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Sat, 12 Dec 2015 15:22:44 +0200")
Message-ID: <87wpsee9um.fsf@kamboji.qca.qualcomm.com> (sfid-20151216_153939_734572_F20FC253)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
>
> When network interface is stopping, some resources may
> be already released by the network stack, and Rx frames
> cause kernel OOPS (observed one is in netfilter code)
>
> Proper solution is to drop packets pending in reorder buffer.
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

This is missing Hamad's Signed-off-by line. It should be the first
before Vladimir's and yours.

-- 
Kalle Valo
