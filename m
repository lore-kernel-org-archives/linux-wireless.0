Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37821 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3KFJz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 04:55:57 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: add phyerr/dfs handling
References: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
Date: Wed, 6 Nov 2013 11:55:48 +0200
In-Reply-To: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Tue, 29 Oct 2013 13:06:32 +0100")
Message-ID: <8738n9ua57.fsf@kamboji.qca.qualcomm.com> (sfid-20131106_105600_517283_30BF2E22)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> Handle phyerr, dfs event, radar_report and fft_report.
> Add also debugfs dfs_simulate_radar and dfs_stats files.
> Use ath dfs pattern detector.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Forgot to mention that after I applied these three patches I saw two new
checkpatch warnings:

drivers/net/wireless/ath/ath10k/debug.c:684: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/wmi.c:1544: WARNING: line over 80 characters

-- 
Kalle Valo
