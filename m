Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54301 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbbAZNgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 08:36:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 08/10] wil6210: Tx status
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1422175971-8075-9-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Mon, 26 Jan 2015 15:36:29 +0200
In-Reply-To: <1422175971-8075-9-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Sun, 25 Jan 2015 10:52:49 +0200")
Message-ID: <87oaplfyua.fsf@kamboji.qca.qualcomm.com> (sfid-20150126_143655_524969_5C336B4E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Implement Tx status reporting
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

I think the title is too short. I would like to change it to this, is
that ok?

wil6210: implement skb Tx status reporting

Implment Tx status reporting using skb_complete_wifi_ack().

-- 
Kalle Valo
