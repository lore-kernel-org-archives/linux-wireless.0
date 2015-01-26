Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54477 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbbAZNiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 08:38:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 09/10] wil6210: probe_client
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1422175971-8075-10-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Mon, 26 Jan 2015 15:38:12 +0200
In-Reply-To: <1422175971-8075-10-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Sun, 25 Jan 2015 10:52:50 +0200")
Message-ID: <87k309fyrf.fsf@kamboji.qca.qualcomm.com> (sfid-20150126_143821_955097_2B04A73D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Access point require this API to check peer alive status.
> Assume peer is alive when it is connected, because
> firmware implements keep alive checks and will disconnect
> peer if it is not alive.
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Here the title is again too short, is it ok if I change it to this:

wil6210: implement cfg80211 probe_client() op

-- 
Kalle Valo
