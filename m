Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32471 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcCBN4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 08:56:00 -0500
Date: Wed, 2 Mar 2016 16:55:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Geliang Tang <geliangtang@163.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix static checker warning
Message-ID: <20160302135522.GA32153@mwanda> (sfid-20160302_145621_238184_C6DD01C0)
References: <20160223050421.GA19763@mwanda>
 <1e3c203b20c01a12078506469807a79ae6013955.1456845195.git.geliangtang@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1e3c203b20c01a12078506469807a79ae6013955.1456845195.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 01, 2016 at 11:22:23PM +0800, Geliang Tang wrote:
> Fix the following static checker warning:
> 
>  drivers/staging/rtl8723au/core/rtw_sta_mgt.c:365 rtw_get_stainfo23a()
>  error: potential NULL dereference 'psta'.
> 
> Fixes: e280d71("staging: rtl8723au: use list_for_each_entry*()")
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Looks good.  Thanks.

regards,
dan carpenter

