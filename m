Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:35961 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbcAZXQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 18:16:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWawou1Z_NnAzM5TxH7TUQUCAhf+k96PErNV8q_SOCShw@mail.gmail.com>
References: <1453830820-27104-1-git-send-email-xiyou.wangcong@gmail.com>
 <CAGRGNgV7MUXdk+e8Arx05yiWX6owei5dmnFQ-TBfs55jfy+qBw@mail.gmail.com> <CAM_iQpWawou1Z_NnAzM5TxH7TUQUCAhf+k96PErNV8q_SOCShw@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 27 Jan 2016 10:15:57 +1100
Message-ID: <CAGRGNgXSbo1ZjFda5qyg8cesddTSUO2=rMEsopzHDuVBpHJqaA@mail.gmail.com> (sfid-20160127_001626_076765_53B36E84)
Subject: Re: [PATCH RESEND net] nfc: use GFP_USER for user-controlled kmalloc
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cong,

On Wed, Jan 27, 2016 at 10:12 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Jan 26, 2016 at 2:55 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Cong,
>>
>> On Wed, Jan 27, 2016 at 4:53 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>
>> A commit message would be nice. A brief rundown of how this is called
>> from userspace would be nice (I'm talking a single sentence here, e.g.
>> "this is allocated when submitting a nfc packet") and what issue
>> __GFP_NOWARN is fixing. (I'm guessing log spam due to allocation
>> failures.)
>>
>
> I thought it is obvious. ;) Keep in mind that $subject is one part of commit
> message too, so there is a commit message although very short.
>
> I will add it.

I know almost nothing about how the NFC subsystem works, and this
looks like a potential security issue, so more information is better
IMHO.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
