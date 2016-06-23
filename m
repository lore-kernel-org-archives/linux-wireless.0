Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35072 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbcFWBaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 21:30:11 -0400
MIME-Version: 1.0
In-Reply-To: <1466599154-4782-1-git-send-email-luisbg@osg.samsung.com>
References: <1466599154-4782-1-git-send-email-luisbg@osg.samsung.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 23 Jun 2016 11:29:45 +1000
Message-ID: <CAGRGNgUoptASqK7jD-K-=zp7eYbJDq+2+u7mj_MabaGtOb9=kQ@mail.gmail.com> (sfid-20160623_033059_783352_309C898C)
Subject: Re: [PATCH] staging: wilc1000: fix error handling in wilc_debugfs_init()
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Wed, Jun 22, 2016 at 10:39 PM, Luis de Bethencourt
<luisbg@osg.samsung.com> wrote:
> The common format to check if a function returned an error pointer is to
> use PTR_ERR(). Instead of ERR_PTR() which is used to return said errors.
>
> Also, if there was an error returning -EINVAL instead of -1 is more
> appropriate.

These two changes could be argued to be separate changes deserving of
their own patches.

> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>

However if everyone else is ok with that, this is:

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
