Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49494 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab2C2KVx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Thu, 29 Mar 2012 06:21:53 -0400
Received: by bkcik5 with SMTP id ik5so1780290bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 03:21:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120329094055.GC2351@redhat.com>
References: <1332829680-32457-1-git-send-email-machen@suse.com>
	<20120327123822.GA2565@redhat.com>
	<CALx5=V-aouK2ge3f2EQa07n2oJZRBXQGf15pXUdbsk6BjE+cdg@mail.gmail.com>
	<CALx5=V9++V8c-=Nu5X6rigkMcU5Lv6tgn9wn7DS4pwn4P0Yr-A@mail.gmail.com>
	<20120329094055.GC2351@redhat.com>
Date: Thu, 29 Mar 2012 18:21:34 +0800
Message-ID: <CALx5=V-LOs_a0f=cNF68Xjf+G8JtLDHxHJwQnWwzmkMHQOw8hQ@mail.gmail.com> (sfid-20120329_122155_870219_D46FD031)
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2x00dev: move rfkill_polling
 register to proper place
From: Matt Chen <machen@suse.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=Big5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

2012/3/29 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Thu, Mar 29, 2012 at 10:50:25AM +0800, Matt Chen wrote:
>> Hi John,
>>
>> Would it be possible to merge my patch to v3.4 merging ¡H
>> It would be great if this patch got merged. This patch fixes an
>> initialization of probing pci device. Since a lot users reported the
>> issue is making no sense after rebooting the machine and got No
>> wireless device working due to rfkill is not yet started to work.
>>
>> Thank you for your kindly help. :)
>>
>> Would it be possible to merge this patch into v3.4 tree before the
>> merging window closed ?
> Since patch is a fix, it could be applied after merge window. But first
> you should fix sign-off's and repost.
OK, repost and also mail to John.
Thanks for your reminding. :)
> Stanislaw
>



-- 
Thank you.
