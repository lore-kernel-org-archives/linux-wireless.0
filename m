Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51059 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbcCKMhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 07:37:40 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 000/113] rtl8xxxu: Add support for rtl8723bu
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Date: Fri, 11 Mar 2016 14:37:34 +0200
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Mon, 29 Feb 2016 17:03:58 -0500")
Message-ID: <87io0tmbqp.fsf@kamboji.qca.qualcomm.com> (sfid-20160311_133744_644835_6C251B3B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> This is a rather large set of patches adding support for rtl8723bu
> devices, as well as containing some code for rtl8192eu devices.
>
> I started working on 8192eu support at the beginning but later
> switched over and completed 8723bu support, before finally completing
> 8192eu support. The two new devices share a lot of new features not
> found in the older generation parts (8723au/8188cu/8192cu/8188ru).
>
> I am holding back the 8192eu support for now, in order to reduce the
> size of the patch set (I have another 60 patches that goes on top of
> this set with 8192eu support and additional bug fixes). Given that
> support for the two devices is intermingled, trying to disentangle it
> is pretty much impossible at this point, and risks breaking the code.
>
> This applies on top of wireless-drivers-next as of today 2016-02-29.

First of all, a huge patchset like this automatically goes to the bottom
of my queue. 113 patches is wrong in so many levels, it makes review
really hard, making changes in patches is difficult and whatnot. I think
that 10-15 patches per set is optimal, please try to follow that. Don't
sit on the patches for too long, send them as fast as you can. "Release
early, release often"

I have applied this to wireless-drivers-next, this time, but in the
future please keep the patch count in reasonable levels. The merge
window is getting closer so I'm not sure if these make it to 4.6 but I
would guess I can still squeeze them in.

-- 
Kalle Valo
