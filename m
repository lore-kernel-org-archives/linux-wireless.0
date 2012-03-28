Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:47686 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2C1Cd0 (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 27 Mar 2012 22:33:26 -0400
Received: by bkcik5 with SMTP id ik5so482687bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2012 19:33:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120327123822.GA2565@redhat.com>
References: <1332829680-32457-1-git-send-email-machen@suse.com>
	<20120327123822.GA2565@redhat.com>
Date: Wed, 28 Mar 2012 10:33:09 +0800
Message-ID: <CALx5=V-aouK2ge3f2EQa07n2oJZRBXQGf15pXUdbsk6BjE+cdg@mail.gmail.com> (sfid-20120328_043329_220225_A914BFD5)
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2x00dev: move rfkill_polling
 register to proper place
From: Matt Chen <machen@suse.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

2012/3/27 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Tue, Mar 27, 2012 at 02:28:00PM +0800, Chen, Chien-Chia wrote:
>> Move rt2x00rfkill_register(rt2x00dev) to rt2x00lib_probe_dev().
>> It fixes of starting rfkill_poll function at the right time if
>> sets hard rfkill block and reboot. rt2x00mac_rfkill_poll should
>> be starting before bringing up the wireless interface.
>>
>> Signed-off-by: Kevin Chou <kevin.chou@mediatek.com>
> You should sign off the patch, and probably add "From:" to mark real
> author of the patch, and CC Kevin as well.
Yes, thank you for information of patch format. :)
> Stanislaw
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>



-- 
Thank you.
