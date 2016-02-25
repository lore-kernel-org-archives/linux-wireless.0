Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44101 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759087AbcBYHn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 02:43:29 -0500
Date: Thu, 25 Feb 2016 08:43:17 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org, dvyukov@google.com,
	linux-wireless@vger.kernel.org, julian.calaby@gmail.com,
	eric.dumazet@gmail.com,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH v2 net] nfc: use GFP_USER for user-controlled kmalloc
Message-ID: <20160225074317.GA9068@zurbaran.home> (sfid-20160225_084403_114620_179EE070)
References: <1454095465-16685-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454095465-16685-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cong,

On Fri, Jan 29, 2016 at 11:24:24AM -0800, Cong Wang wrote:
> These two functions are called in sendmsg path, and the
> 'len' is passed from user-space, so we should not allow
> malicious users to OOM kernel on purpose.
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/nfc/llcp_commands.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied to nfc-next, thanks.

Cheers,
Samuel.
