Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39855 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab2C2Cuj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Wed, 28 Mar 2012 22:50:39 -0400
Received: by bkcik5 with SMTP id ik5so1533117bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Mar 2012 19:50:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALx5=V-aouK2ge3f2EQa07n2oJZRBXQGf15pXUdbsk6BjE+cdg@mail.gmail.com>
References: <1332829680-32457-1-git-send-email-machen@suse.com>
	<20120327123822.GA2565@redhat.com>
	<CALx5=V-aouK2ge3f2EQa07n2oJZRBXQGf15pXUdbsk6BjE+cdg@mail.gmail.com>
Date: Thu, 29 Mar 2012 10:50:25 +0800
Message-ID: <CALx5=V9++V8c-=Nu5X6rigkMcU5Lv6tgn9wn7DS4pwn4P0Yr-A@mail.gmail.com> (sfid-20120329_045043_037026_E83ED4BD)
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2x00dev: move rfkill_polling
 register to proper place
From: Matt Chen <machen@suse.com>
To: linville@tuxdriver.com
Cc: users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=Big5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Would it be possible to merge my patch to v3.4 merging ¡H
It would be great if this patch got merged. This patch fixes an
initialization of probing pci device. Since a lot users reported the
issue is making no sense after rebooting the machine and got No
wireless device working due to rfkill is not yet started to work.

Thank you for your kindly help. :)

Would it be possible to merge this patch into v3.4 tree before the
merging window closed ?

2012/3/28 Matt Chen <machen@suse.com>:
> Hi all,
>
> 2012/3/27 Stanislaw Gruszka <sgruszka@redhat.com>:
>> On Tue, Mar 27, 2012 at 02:28:00PM +0800, Chen, Chien-Chia wrote:
>>> Move rt2x00rfkill_register(rt2x00dev) to rt2x00lib_probe_dev().
>>> It fixes of starting rfkill_poll function at the right time if
>>> sets hard rfkill block and reboot. rt2x00mac_rfkill_poll should
>>> be starting before bringing up the wireless interface.
>>>
>>> Signed-off-by: Kevin Chou <kevin.chou@mediatek.com>
>> You should sign off the patch, and probably add "From:" to mark real
>> author of the patch, and CC Kevin as well.
> Yes, thank you for information of patch format. :)
>> Stanislaw
>>
>> _______________________________________________
>> users mailing list
>> users@rt2x00.serialmonkey.com
>> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>>
>
>
>
> --
> Thank you.



-- 
Thank you.
