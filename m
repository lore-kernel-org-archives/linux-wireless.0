Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33408 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964864AbcCPJm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 05:42:29 -0400
MIME-Version: 1.0
In-Reply-To: <87pouulqut.fsf@kamboji.qca.qualcomm.com>
References: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com> <1453423965.3856.22.camel@perches.com>
 <87k2n1x0sf.fsf@kamboji.qca.qualcomm.com> <20160122151211.GB1500@tuxdriver.com>
 <87si1pvcd7.fsf@kamboji.qca.qualcomm.com> <20160126052823.GA2053@sudip-laptop>
 <87bn84kdu0.fsf@kamboji.qca.qualcomm.com> <20160201044142.GC4072@sudip-pc>
 <878u34j0wz.fsf@kamboji.qca.qualcomm.com> <CAGRGNgWkqApcjtEq_K8PQugoHxUSBxfSGJE1Mc+3_W2H9J8GrQ@mail.gmail.com>
 <87pouulqut.fsf@kamboji.qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 16 Mar 2016 20:42:09 +1100
Message-ID: <CAGRGNgX=a9gfnYG6eW2p1CnHnH22pFO7_pDcF4pHSieeUC2s-Q@mail.gmail.com> (sfid-20160316_104249_434918_2F0FE89E)
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

On Wed, Mar 16, 2016 at 8:22 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Julian Calaby <julian.calaby@gmail.com> writes:
>
>> Hi Kalle,
>>
>> On Mon, Feb 1, 2016 at 7:21 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:
>>>
>>>> Sure, I am starting that way. I checked in patchwork and I do not see
>>>> any checkpatch related patch pending (except staging, which Greg will
>>>> handle). I think you must have cleared all of them.
>>>
>>> They are in deferred state. The search functionality in patchwork is not
>>> that intuitive and they are not easy to find so here's a direct link:
>>>
>>> https://patchwork.kernel.org/project/linux-wireless/list/?state=10&order=date
>>
>> I'm currently going through that list and producing a bundle of
>> "applyable" patches.
>
> Nice.

Thanks, I figured that checking the deferred list on patchwork at some
point would be a good plan. After a release seemed like a good time to
do it.

>> My criteria is:
>> 1. The change is sane.
>> 2. It's either obviously correct, I can review it, or someone else has
>> reviewed or acked it.
>> 3. No changes other than rebasing and fixing commit messages are
>> required to apply it.
>
> BTW, 'git am -s -3' is the best way to apply a patch. The three way
> merge is awesome (if the submitter has sent the patch correctly).
>
>> Some of these patches need work on their commit messages, some are
>> complicated enough that I feel I should be providing review notes so
>> someone else can double check my review, and all of them should be
>> rebased and compile tested. Also, some are controversial, so I'll be
>> segregating them from the main set.
>>
>> How would you like me to communicate this list to you? I'm happy to
>> provide branches you can pull from or I could just post updated
>> versions to the list and give reviewed-by tags to those that don't
>> need more work.
>>
>> Every patch will get an email on linux-wireless regardless.
>
> I guess posting the patches to linux-wireless is the easiest for
> everyone? I have a script which automatically takes patches from
> patchwork so that's very easy for me. But remember to use Signed-off-by
> instead of Reviewed-by as you are resending the patches.

If they end up being exactly identical to the original, I'll just add
reviewed-bys to the original patches, otherwise I'll do exactly that.

> Thanks you, your help here is very much appreciated.

No problem!

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
