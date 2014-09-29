Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39918 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaI2L3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 07:29:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: wil6210 <wil6210@qca.qualcomm.com>, <netdev@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ath10k@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<ath6kl@lists.infradead.org>
Subject: Re: [PATCH] ath: change logging functions to return void
References: <1411407334.2952.46.camel@joe-AO725>
Date: Mon, 29 Sep 2014 14:28:42 +0300
In-Reply-To: <1411407334.2952.46.camel@joe-AO725> (Joe Perches's message of
	"Mon, 22 Sep 2014 10:35:34 -0700")
Message-ID: <87h9zq1x91.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_132911_926488_998D61D1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> The return values are not used by callers of these functions
> so change the functions to return void.
>
> Other miscellanea:
>
> o add __printf verification to wil6210 logging functions
>   No format/argument mismatches found
>
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, applied.

-- 
Kalle Valo
