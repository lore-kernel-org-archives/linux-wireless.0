Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14596 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbcCDIjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:39:54 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: remove impossible code
Date: Fri, 4 Mar 2016 08:39:49 +0000
Message-ID: <87io12zlf4.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_094018_296421_F2F3E3FC)
References: <1454397280-4758-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1454397280-4758-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Tue, 2 Feb 2016 12:44:40 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

> From: Sudip Mukherjee <sudip@vectorindia.org>
>
> len has been initialized with a value of 0 and buf_len with 4096. There
> is no way that this condition (len > buf_len) can be true now.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Applied, thanks.

-- 
Kalle Valo