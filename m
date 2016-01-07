Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48358 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbcAGJMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:12:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: correctly handling kzalloc
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1451491304-35251-1-git-send-email-wuninsu@gmail.com>
To: Insu Yun <wuninsu@gmail.com>
Cc: akarwar@marvell.com, nishants@marvell.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu,
	yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu,
	Insu Yun <wuninsu@gmail.com>
Message-Id: <20160107091230.C5B58605BF@smtp.codeaurora.org> (sfid-20160107_101336_042491_6B533225)
Date: Thu,  7 Jan 2016 09:12:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Since kzalloc can be failed in memory pressure,
> it needs to be handled, otherwise NULL dereference could be happened
> 
> Signed-off-by: Insu Yun <wuninsu@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
