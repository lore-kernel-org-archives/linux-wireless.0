Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39496 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1KXMag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 07:30:36 -0500
Message-ID: <4ECE38B9.4080902@qca.qualcomm.com> (sfid-20111124_133041_213391_67E2A07D)
Date: Thu, 24 Nov 2011 14:29:45 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch v2] ath6kl: use a larger buffer for debug output
References: <20111118140906.GA9685@elgon.mountain> <1321625461.10266.57.camel@jlt3.sipsolutions.net> <20111123063450.GA3363@mwanda>
In-Reply-To: <20111123063450.GA3363@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2011 08:34 AM, Dan Carpenter wrote:
> The return value of snprintf() is the number of bytes which would
> have been copied if there was enough space, but we want the number of
> bytes actually copied.  The scnprintf() function does this.
> 
> Also in theory, a %u can take take 10 digits so we may as well make
> the buffer larger as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

> v2:  I didn't know about the scnprintf() function before.  Thanks
> Johannes.

Me neither, so thank you from me as well :)

Kalle
