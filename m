Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46826 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbbFILqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 07:46:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 0/6] wil6210 patches
References: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Tue, 09 Jun 2015 14:45:55 +0300
In-Reply-To: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Sun, 7 Jun 2015 16:56:25 +0300")
Message-ID: <87r3plds0c.fsf@kamboji.qca.qualcomm.com> (sfid-20150609_134605_008949_0C834F88)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Small fixes here and there; save for hidden SSID
>
> Hamad Kadmany (1):
>   wil6210: Support hidden SSID
>
> Vladimir Kondratiev (5):
>   wil6210: modparam for bcast ring size
>   wil6210: add NIC memory region mac_rgf_ext
>   wil6210: add per-MCS Rx stats
>   wil6210: platform hooks for modile init/exit
>   wil6210: reorder init sequence

Thanks, all six applied.

-- 
Kalle Valo
