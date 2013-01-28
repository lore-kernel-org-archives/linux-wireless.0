Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3A1J4w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:56:52 -0500
Date: Mon, 28 Jan 2013 10:56:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: iwlegacy: remove unused variable
Message-ID: <20130128095640.GA2316@redhat.com> (sfid-20130128_105700_373537_FE10101F)
References: <1359312941-30661-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1359312941-30661-1-git-send-email-linux@roeck-us.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 27, 2013 at 10:55:41AM -0800, Guenter Roeck wrote:
> drivers/net/wireless/iwlegacy/4965.c: In function ‘il4965_post_associate’:
> drivers/net/wireless/iwlegacy/4965.c:1751:25: warning: variable ‘conf’ set but
> not used [-Wunused-but-set-variable]
> 
> seen when building allmodconfig on x86_64 with W=1 by removing the unused
> variable.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

ACK
