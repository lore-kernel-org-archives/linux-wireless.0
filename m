Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58528 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbcFWL0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 07:26:25 -0400
Message-ID: <576BC73B.9070503@osg.samsung.com> (sfid-20160623_132643_083108_D2B946F6)
Date: Thu, 23 Jun 2016 12:25:47 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: wilc1000: fix error handling in wilc_debugfs_init()
References: <1466599154-4782-1-git-send-email-luisbg@osg.samsung.com> <CAGRGNgUoptASqK7jD-K-=zp7eYbJDq+2+u7mj_MabaGtOb9=kQ@mail.gmail.com>
In-Reply-To: <CAGRGNgUoptASqK7jD-K-=zp7eYbJDq+2+u7mj_MabaGtOb9=kQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23/06/16 02:29, Julian Calaby wrote:
> Hi All,
> 
> On Wed, Jun 22, 2016 at 10:39 PM, Luis de Bethencourt
> <luisbg@osg.samsung.com> wrote:
>> The common format to check if a function returned an error pointer is to
>> use PTR_ERR(). Instead of ERR_PTR() which is used to return said errors.
>>
>> Also, if there was an error returning -EINVAL instead of -1 is more
>> appropriate.
> 
> These two changes could be argued to be separate changes deserving of
> their own patches.
> 
>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> 
> However if everyone else is ok with that, this is:
> 
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
> 
> Thanks,
> 

Hi Julian,

If you don't mind I will resend as two separate patches and include your
Reviewed-by in both.

Thanks for the review,
Luis
