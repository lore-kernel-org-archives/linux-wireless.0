Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57946 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbAOMha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:37:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 00/22] wil6210 patches
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Thu, 15 Jan 2015 14:37:23 +0200
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Tue, 23 Dec 2014 09:47:02 +0200")
Message-ID: <87sifcte2j.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_133737_497450_144C2E82)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Several topics:
> - block ack with secure and insecure connection
> - MTU
> - some infrastructure fixes
> - some debugfs changes
>
> Vladimir Kondratiev (22):
>   wil6210: ADDBA/DELBA flows
>   wil6210: simple ADDBA on originator (Tx) side
>   wil6210: allow to configure ADDBA request
>   wil6210: improve debugfs for reorder buffer
>   wil6210: fix disconnect 1 STA in AP
>   wil6210: improve debugfs for VRING
>   wil6210: control AMSDU on Tx side of Block Ack
>   wil6210: delba for responder
>   wil6210: fix max. MPDU size
>   wil6210: consider SNAP header in MTU calculations
>   wil6210: Increase number of associated stations
>   wil6210: use bitmap API for "status"
>   wil6210: fix Tx VRING for STA mode
>   wil6210: rework debugfs for BACK
>   wil6210: detect HW capabilities
>   wil6210: use HW capabilities mask in reset
>   wil6210: add advanced interrupt moderation
>   wil6210: RX high threshold interrupt configuration
>   wil6210: fix reordering for MCAST
>   wil6210: Tx/Rx descriptors documentation
>   wil6210: workaround for BACK establishment race
>   wil6210: relax spinlocks in rx reorder

Thanks, all 22 applied.

-- 
Kalle Valo
