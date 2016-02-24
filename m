Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:34888 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbcBXSxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 13:53:46 -0500
MIME-Version: 1.0
In-Reply-To: <20160224.134521.961009575129127582.davem@davemloft.net>
References: <1454095465-16685-1-git-send-email-xiyou.wangcong@gmail.com>
	<CAM_iQpX3X6YoFeMw2KYjJM8yBHi9=3iapo0+a9Cqtc0cxM_QNA@mail.gmail.com>
	<20160224.134521.961009575129127582.davem@davemloft.net>
Date: Wed, 24 Feb 2016 10:53:45 -0800
Message-ID: <CAM_iQpV3S6xfhCKkwQAsAv6kHeDV5j87AYdbeqJ6AcLMuGLs+g@mail.gmail.com> (sfid-20160224_195354_062779_1F580F34)
Subject: Re: [PATCH v2 net] nfc: use GFP_USER for user-controlled kmalloc
From: Cong Wang <xiyou.wangcong@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 24, 2016 at 10:45 AM, David Miller <davem@davemloft.net> wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Wed, 24 Feb 2016 10:41:29 -0800
>
>> On Fri, Jan 29, 2016 at 11:24 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>> These two functions are called in sendmsg path, and the
>>> 'len' is passed from user-space, so we should not allow
>>> malicious users to OOM kernel on purpose.
>>>
>>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>>> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
>>> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
>>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>>> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>>
>> Ping...
>>
>> David, this patch seems still not applied, I guess you expect NFC
>> maintainer to take it, but this doesn't happen. Could you take it?
>
> The NFC maintainer needs to take this, ping them explicitly if
> you have to.

OK. I think Samuel is looking at it now.

Thanks!
