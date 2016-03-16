Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44105 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965750AbcCPJW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 05:22:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kbuild test robot <lkp@intel.com>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: wireless-drivers: random cleanup patches piling up
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com>
	<1453423965.3856.22.camel@perches.com>
	<87k2n1x0sf.fsf@kamboji.qca.qualcomm.com>
	<20160122151211.GB1500@tuxdriver.com>
	<87si1pvcd7.fsf@kamboji.qca.qualcomm.com>
	<20160126052823.GA2053@sudip-laptop>
	<87bn84kdu0.fsf@kamboji.qca.qualcomm.com>
	<20160201044142.GC4072@sudip-pc>
	<878u34j0wz.fsf@kamboji.qca.qualcomm.com>
	<CAGRGNgWkqApcjtEq_K8PQugoHxUSBxfSGJE1Mc+3_W2H9J8GrQ@mail.gmail.com>
Date: Wed, 16 Mar 2016 11:22:18 +0200
In-Reply-To: <CAGRGNgWkqApcjtEq_K8PQugoHxUSBxfSGJE1Mc+3_W2H9J8GrQ@mail.gmail.com>
	(Julian Calaby's message of "Wed, 16 Mar 2016 11:57:52 +1100")
Message-ID: <87pouulqut.fsf@kamboji.qca.qualcomm.com> (sfid-20160316_102249_357864_2477DAE6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

> Hi Kalle,
>
> On Mon, Feb 1, 2016 at 7:21 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:
>>
>>> Sure, I am starting that way. I checked in patchwork and I do not see
>>> any checkpatch related patch pending (except staging, which Greg will
>>> handle). I think you must have cleared all of them.
>>
>> They are in deferred state. The search functionality in patchwork is not
>> that intuitive and they are not easy to find so here's a direct link:
>>
>> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&order=date
>
> I'm currently going through that list and producing a bundle of
> "applyable" patches.

Nice.

> My criteria is:
> 1. The change is sane.
> 2. It's either obviously correct, I can review it, or someone else has
> reviewed or acked it.
> 3. No changes other than rebasing and fixing commit messages are
> required to apply it.

BTW, 'git am -s -3' is the best way to apply a patch. The three way
merge is awesome (if the submitter has sent the patch correctly).

> Some of these patches need work on their commit messages, some are
> complicated enough that I feel I should be providing review notes so
> someone else can double check my review, and all of them should be
> rebased and compile tested. Also, some are controversial, so I'll be
> segregating them from the main set.
>
> How would you like me to communicate this list to you? I'm happy to
> provide branches you can pull from or I could just post updated
> versions to the list and give reviewed-by tags to those that don't
> need more work.
>
> Every patch will get an email on linux-wireless regardless.

I guess posting the patches to linux-wireless is the easiest for
everyone? I have a script which automatically takes patches from
patchwork so that's very easy for me. But remember to use Signed-off-by
instead of Reviewed-by as you are resending the patches.

Thanks you, your help here is very much appreciated.

-- 
Kalle Valo
