Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53122 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaKZHMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 02:12:10 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: add new wmi interface of NF cal period
References: <1416945765-26902-1-git-send-email-poh@qca.qualcomm.com>
	<1416945765-26902-2-git-send-email-poh@qca.qualcomm.com>
Date: Wed, 26 Nov 2014 09:12:04 +0200
In-Reply-To: <1416945765-26902-2-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Tue, 25 Nov 2014 12:02:45 -0800")
Message-ID: <874mtmxwor.fsf@kamboji.qca.qualcomm.com> (sfid-20141126_081213_947479_A5FC6398)
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

There was a trivial conflict in struct ath10k_debug, please double check
my conflict resolution:

https://github.com/kvalo/ath/commit/1abcc1aa6046231a55a296ea78ab2f374f6f791b

-- 
Kalle Valo
