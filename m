Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34409 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbcCPA6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 20:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <878u34j0wz.fsf@kamboji.qca.qualcomm.com>
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com> <1453423965.3856.22.camel@perches.com>
 <87k2n1x0sf.fsf@kamboji.qca.qualcomm.com> <20160122151211.GB1500@tuxdriver.com>
 <87si1pvcd7.fsf@kamboji.qca.qualcomm.com> <20160126052823.GA2053@sudip-laptop>
 <87bn84kdu0.fsf@kamboji.qca.qualcomm.com> <20160201044142.GC4072@sudip-pc> <878u34j0wz.fsf@kamboji.qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 16 Mar 2016 11:57:52 +1100
Message-ID: <CAGRGNgWkqApcjtEq_K8PQugoHxUSBxfSGJE1Mc+3_W2H9J8GrQ@mail.gmail.com> (sfid-20160316_015832_890835_C851C47C)
Subject: Re: wireless-drivers: random cleanup patches piling up
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kbuild test robot <lkp@intel.com>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Mon, Feb 1, 2016 at 7:21 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:
>
>> Sure, I am starting that way. I checked in patchwork and I do not see
>> any checkpatch related patch pending (except staging, which Greg will
>> handle). I think you must have cleared all of them.
>
> They are in deferred state. The search functionality in patchwork is not
> that intuitive and they are not easy to find so here's a direct link:
>
> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&order=date

I'm currently going through that list and producing a bundle of
"applyable" patches.

My criteria is:
1. The change is sane.
2. It's either obviously correct, I can review it, or someone else has
reviewed or acked it.
3. No changes other than rebasing and fixing commit messages are
required to apply it.

Some of these patches need work on their commit messages, some are
complicated enough that I feel I should be providing review notes so
someone else can double check my review, and all of them should be
rebased and compile tested. Also, some are controversial, so I'll be
segregating them from the main set.

How would you like me to communicate this list to you? I'm happy to
provide branches you can pull from or I could just post updated
versions to the list and give reviewed-by tags to those that don't
need more work.

Every patch will get an email on linux-wireless regardless.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
