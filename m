Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38801 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbcDDPEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 11:04:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 1/2] wil6210: allow empty WMI commands in debugfs wmi_send
References: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1458590472-677-2-git-send-email-qca_merez@qca.qualcomm.com>
Date: Mon, 04 Apr 2016 18:04:20 +0300
In-Reply-To: <1458590472-677-2-git-send-email-qca_merez@qca.qualcomm.com>
	(Maya Erez's message of "Mon, 21 Mar 2016 22:01:11 +0200")
Message-ID: <87r3elct57.fsf@kamboji.qca.qualcomm.com> (sfid-20160404_170428_846374_0697A3A9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Lior David <qca_liord@qca.qualcomm.com>
>
> There are many valid WMI commands with only header without any
> additional payload. Such WMI commands could not be sent using
> the debugfs wmi_send facility. Fix the code to allow sending
> of such commands.
>
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Patch 1 applied to ath.git, thanks.

-- 
Kalle Valo
