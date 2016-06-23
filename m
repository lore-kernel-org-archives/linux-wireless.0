Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38509 "EHLO
	mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbcFWL3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 07:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <576BC73B.9070503@osg.samsung.com>
References: <1466599154-4782-1-git-send-email-luisbg@osg.samsung.com>
 <CAGRGNgUoptASqK7jD-K-=zp7eYbJDq+2+u7mj_MabaGtOb9=kQ@mail.gmail.com> <576BC73B.9070503@osg.samsung.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 23 Jun 2016 21:29:30 +1000
Message-ID: <CAGRGNgW52h=X1_Pac+VJKmpBC_MODzu00JnfDOk180FYmvPKyg@mail.gmail.com> (sfid-20160623_133009_422834_1190A444)
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

Hi Luis,

On Thu, Jun 23, 2016 at 9:25 PM, Luis de Bethencourt
<luisbg@osg.samsung.com> wrote:
> On 23/06/16 02:29, Julian Calaby wrote:
>> Hi All,
>>
>> On Wed, Jun 22, 2016 at 10:39 PM, Luis de Bethencourt
>> <luisbg@osg.samsung.com> wrote:
>>> The common format to check if a function returned an error pointer is to
>>> use PTR_ERR(). Instead of ERR_PTR() which is used to return said errors.
>>>
>>> Also, if there was an error returning -EINVAL instead of -1 is more
>>> appropriate.
>>
>> These two changes could be argued to be separate changes deserving of
>> their own patches.
>>
>>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
>>
>> However if everyone else is ok with that, this is:
>>
>> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
>>
>> Thanks,
>>
>
> Hi Julian,
>
> If you don't mind I will resend as two separate patches and include your
> Reviewed-by in both.

Providing there are no changes other than rebasing and splitting, I'm
fine with that.,

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
