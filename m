Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35122 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbbI2Hi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:38:59 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: carl9170: fix bad rssi reading
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1441908285-606-1-git-send-email-hiroaki.kawai@gmail.com>
To: Hiroaki KAWAI <hiroaki.kawai@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Hiroaki KAWAI <hiroaki.kawai@gmail.com>
Message-Id: <20150929073858.7C6D1140C83@smtp.codeaurora.org> (sfid-20150929_093902_420086_4CBE3DF5)
Date: Tue, 29 Sep 2015 07:38:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Fix rssi calculation error which was introduced in otus to ar9170
> porting.
> 
> Signed-off-by: Hiroaki KAWAI <hiroaki.kawai@gmail.com>
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
