Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52533 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbEINrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:47:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: do not return success when command times out
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150430235202.GA35256@dtor-ws>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20150509134744.C0E9D14011B@smtp.codeaurora.org> (sfid-20150509_154806_290162_DE1C26C6)
Date: Sat,  9 May 2015 13:47:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> wait_event_interruptible_timeout() returns 0 upon timeout. We should
> convert it to a negative error code (such as -ETIMEDOUT) instead of
> returning it directly, as return code of 0 indicates that command was
> executed.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
