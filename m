Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43597 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3KSOtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 09:49:36 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ath10k: add phyerr/dfs handling
References: <1384418018-4973-1-git-send-email-marek.puzyniak@tieto.com>
Date: Tue, 19 Nov 2013 16:49:30 +0200
In-Reply-To: <1384418018-4973-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Thu, 14 Nov 2013 09:33:36 +0100")
Message-ID: <87vbzo1m6d.fsf@kamboji.qca.qualcomm.com> (sfid-20131119_154939_453619_7AB55F9C)
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

Thanks, all three applied.

In the future please add a changelog when you change something in the
patches. It's very difficult to review otherwise.

-- 
Kalle Valo
