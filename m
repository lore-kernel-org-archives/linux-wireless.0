Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24849 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaLBJxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 04:53:41 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: add new wmi interface of NF cal period
References: <1416945765-26902-1-git-send-email-poh@qca.qualcomm.com>
	<1416945765-26902-2-git-send-email-poh@qca.qualcomm.com>
Date: Tue, 2 Dec 2014 11:53:35 +0200
In-Reply-To: <1416945765-26902-2-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Tue, 25 Nov 2014 12:02:45 -0800")
Message-ID: <87tx1enzs0.fsf@kamboji.qca.qualcomm.com> (sfid-20141202_105346_188498_B2A1D930)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Introduce a new wmi interface controls noise floor (NF) calibration
> period via debugfs as firmware has introduced it on v10.2.
>
> It allows users to modify frequency of NF calibration in millisecond
> and changes RSSI reporting frequency consequently.
> Short calibration period will trigger more frequent NF calibration,
> so that RSSI reported in receive frames is more realistic.
>
> Till now calibration was done at 30 seconds.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

This doesn't handle firmware retstarts in any way, let me send v2 to fix
that.

-- 
Kalle Valo
