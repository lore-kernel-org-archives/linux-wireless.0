Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36380 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbcAZXML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 18:12:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAGRGNgV7MUXdk+e8Arx05yiWX6owei5dmnFQ-TBfs55jfy+qBw@mail.gmail.com>
References: <1453830820-27104-1-git-send-email-xiyou.wangcong@gmail.com>
	<CAGRGNgV7MUXdk+e8Arx05yiWX6owei5dmnFQ-TBfs55jfy+qBw@mail.gmail.com>
Date: Tue, 26 Jan 2016 15:12:09 -0800
Message-ID: <CAM_iQpWawou1Z_NnAzM5TxH7TUQUCAhf+k96PErNV8q_SOCShw@mail.gmail.com> (sfid-20160127_001214_839963_3160555F)
Subject: Re: [PATCH RESEND net] nfc: use GFP_USER for user-controlled kmalloc
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2016 at 2:55 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Cong,
>
> On Wed, Jan 27, 2016 at 4:53 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> A commit message would be nice. A brief rundown of how this is called
> from userspace would be nice (I'm talking a single sentence here, e.g.
> "this is allocated when submitting a nfc packet") and what issue
> __GFP_NOWARN is fixing. (I'm guessing log spam due to allocation
> failures.)
>

I thought it is obvious. ;) Keep in mind that $subject is one part of commit
message too, so there is a commit message although very short.

I will add it.
