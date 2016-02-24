Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbcBXSw1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 13:52:27 -0500
Date: Wed, 24 Feb 2016 19:52:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH v2 net] nfc: use GFP_USER for user-controlled kmalloc
Message-ID: <20160224185226.GA23748@zurbaran.home> (sfid-20160224_195234_605194_D8F73710)
References: <1454095465-16685-1-git-send-email-xiyou.wangcong@gmail.com>
 <CAM_iQpX3X6YoFeMw2KYjJM8yBHi9=3iapo0+a9Cqtc0cxM_QNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM_iQpX3X6YoFeMw2KYjJM8yBHi9=3iapo0+a9Cqtc0cxM_QNA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 24, 2016 at 10:41:29AM -0800, Cong Wang wrote:
> On Fri, Jan 29, 2016 at 11:24 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > These two functions are called in sendmsg path, and the
> > 'len' is passed from user-space, so we should not allow
> > malicious users to OOM kernel on purpose.
> >
> > Reported-by: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> > Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> 
> Ping...
> 
> David, this patch seems still not applied, I guess you expect NFC
> maintainer to take it, but this doesn't happen. Could you take it?
I'll look at it later today.

Cheers,
Samuel.
