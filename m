Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbcCKTqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 14:46:54 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 000/113] rtl8xxxu: Add support for rtl8723bu
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<87io0tmbqp.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 11 Mar 2016 14:46:53 -0500
In-Reply-To: <87io0tmbqp.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Fri, 11 Mar 2016 14:37:34 +0200")
Message-ID: <wrfj8u1o6bma.fsf@redhat.com> (sfid-20160311_204657_814671_3D8D8840)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> This is a rather large set of patches adding support for rtl8723bu
>> devices, as well as containing some code for rtl8192eu devices.
>>
>> I started working on 8192eu support at the beginning but later
>> switched over and completed 8723bu support, before finally completing
>> 8192eu support. The two new devices share a lot of new features not
>> found in the older generation parts (8723au/8188cu/8192cu/8188ru).
>>
>> I am holding back the 8192eu support for now, in order to reduce the
>> size of the patch set (I have another 60 patches that goes on top of
>> this set with 8192eu support and additional bug fixes). Given that
>> support for the two devices is intermingled, trying to disentangle it
>> is pretty much impossible at this point, and risks breaking the code.
>>
>> This applies on top of wireless-drivers-next as of today 2016-02-29.
>
> First of all, a huge patchset like this automatically goes to the bottom
> of my queue. 113 patches is wrong in so many levels, it makes review
> really hard, making changes in patches is difficult and whatnot. I think
> that 10-15 patches per set is optimal, please try to follow that. Don't
> sit on the patches for too long, send them as fast as you can. "Release
> early, release often"
>
> I have applied this to wireless-drivers-next, this time, but in the
> future please keep the patch count in reasonable levels. The merge
> window is getting closer so I'm not sure if these make it to 4.6 but I
> would guess I can still squeeze them in.

Thanks!

The follow-on sets will be smaller, especially as the base
infrastructure is now in which covers the gen2 chips.

Cheers,
Jes
