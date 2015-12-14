Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20065 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbbLNLU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 06:20:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: allow Mesh Point to install peer security key
References: <1449165055-27782-1-git-send-email-poh@qca.qualcomm.com>
Date: Mon, 14 Dec 2015 13:20:16 +0200
In-Reply-To: <1449165055-27782-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Thu, 3 Dec 2015 09:50:55 -0800")
Message-ID: <877fkh46q7.fsf@kamboji.qca.qualcomm.com> (sfid-20151214_122038_673379_50AA9E62)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Mesh Point requires peer security key install when running
> in secured mode since it's a type of peer links, otherwise peer
> link will be removed due to key install failure.
>
> MFP feature set is required to run Mesh in secured mode and
> QCA988X firmware, 10.2.4.70.14-2 and above, is the only one
> supporting secured Mesh at this moment.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
