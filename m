Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36726 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbcCRBGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 21:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAGRGNgX=a9gfnYG6eW2p1CnHnH22pFO7_pDcF4pHSieeUC2s-Q@mail.gmail.com>
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com> <1453423965.3856.22.camel@perches.com>
 <87k2n1x0sf.fsf@kamboji.qca.qualcomm.com> <20160122151211.GB1500@tuxdriver.com>
 <87si1pvcd7.fsf@kamboji.qca.qualcomm.com> <20160126052823.GA2053@sudip-laptop>
 <87bn84kdu0.fsf@kamboji.qca.qualcomm.com> <20160201044142.GC4072@sudip-pc>
 <878u34j0wz.fsf@kamboji.qca.qualcomm.com> <CAGRGNgWkqApcjtEq_K8PQugoHxUSBxfSGJE1Mc+3_W2H9J8GrQ@mail.gmail.com>
 <87pouulqut.fsf@kamboji.qca.qualcomm.com> <CAGRGNgX=a9gfnYG6eW2p1CnHnH22pFO7_pDcF4pHSieeUC2s-Q@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 Mar 2016 12:06:00 +1100
Message-ID: <CAGRGNgUWJoo7zktRsPHmeJ=9EEhGu4hA042Y37_0sDVQCW8p-Q@mail.gmail.com> (sfid-20160318_020643_729081_4BD2D08E)
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

On Wed, Mar 16, 2016 at 8:42 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Kalle,
>
> On Wed, Mar 16, 2016 at 8:22 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Julian Calaby <julian.calaby@gmail.com> writes:
>>
>>> Hi Kalle,
>>>
>>> On Mon, Feb 1, 2016 at 7:21 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>> Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:
>>>>
>>>>> Sure, I am starting that way. I checked in patchwork and I do not see
>>>>> any checkpatch related patch pending (except staging, which Greg will
>>>>> handle). I think you must have cleared all of them.
>>>>
>>>> They are in deferred state. The search functionality in patchwork is not
>>>> that intuitive and they are not easy to find so here's a direct link:
>>>>
>>>> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&order=date
>>>
>>> I'm currently going through that list and producing a bundle of
>>> "applyable" patches.
>>
>> Nice.
>
> Thanks, I figured that checking the deferred list on patchwork at some
> point would be a good plan. After a release seemed like a good time to
> do it.
>
>>> My criteria is:
>>> 1. The change is sane.
>>> 2. It's either obviously correct, I can review it, or someone else has
>>> reviewed or acked it.
>>> 3. No changes other than rebasing and fixing commit messages are
>>> required to apply it.
>>
>> BTW, 'git am -s -3' is the best way to apply a patch. The three way
>> merge is awesome (if the submitter has sent the patch correctly).
>>
>>> Some of these patches need work on their commit messages, some are
>>> complicated enough that I feel I should be providing review notes so
>>> someone else can double check my review, and all of them should be
>>> rebased and compile tested. Also, some are controversial, so I'll be
>>> segregating them from the main set.
>>>
>>> How would you like me to communicate this list to you? I'm happy to
>>> provide branches you can pull from or I could just post updated
>>> versions to the list and give reviewed-by tags to those that don't
>>> need more work.
>>>
>>> Every patch will get an email on linux-wireless regardless.
>>
>> I guess posting the patches to linux-wireless is the easiest for
>> everyone? I have a script which automatically takes patches from
>> patchwork so that's very easy for me. But remember to use Signed-off-by
>> instead of Reviewed-by as you are resending the patches.
>
> If they end up being exactly identical to the original, I'll just add
> reviewed-bys to the original patches, otherwise I'll do exactly that.

I'm going to just repost everything as it'll just be easier at my end.

Git tree: https://github.com/SkUrRiEr/wireless-drivers-pending

I've split the pending patches into 4 sets:

1. Cleanup: patches that weren't reviewed or were just forgotten.
2. Detail: patches that needed a detailed review
3. More Work: patches that only partially fix a problem
4. Controversial: patches people hated but fit my criteria

I'll go into a lot more detail in my cover letter.

At this point, everything in patchwork that's deferred is either:
1. Unreviewable by me (I poked the authors of most of the older
patches yesterday)
2. An earlier version of a patch I picked up
3. Too "new" (less than a couple of months old)

I'll start sending stuff shortly.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
