Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab1HXRC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 13:02:28 -0400
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Alexander Diewald <alex@diewald.cc>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Date: Wed, 24 Aug 2011 10:02:26 -0700
Subject: RE: [iwlagn] System crash on dell e6420 using iwlagn from
 kernel-git
Message-ID: <C5A7FB31FD9AEA42B600BDC3C74F8E000C8BF9C9@orsmsx511.amr.corp.intel.com> (sfid-20110824_190232_776170_BAF9B957)
References: <2EBB96D0C3577D479C54D1243926388D07AE5FFE@mail.ecs-exchange.de>
 <E9954878DD1FB34FAE5187FB88C58A3501998B9CD3@orsmsx506.amr.corp.intel.com>
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3501998B9CD3@orsmsx506.amr.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alex,

I see that there's a null pointer dereference in one of the iwlagn functions. 

Can you point me to the kernel tree you're using?

Thanks,
Meenakshi

>-----Original Message-----
>From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>owner@vger.kernel.org] On Behalf Of Guy, Wey-Yi W
>Sent: Wednesday, August 24, 2011 7:09 AM
>To: Alexander Diewald; linux-wireless@vger.kernel.org
>Cc: Guy, Wey-Yi W
>Subject: RE: [iwlagn] System crash on dell e6420 using iwlagn from kernel-git
>
>Hi Alex,
>
>I am on vacation now and I will asking the right people in the team to look into
>this problem and get back to you.
>
>Thanks
>Wey
>
>-----Original Message-----
>From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>owner@vger.kernel.org] On Behalf Of Alexander Diewald
>Sent: Wednesday, August 24, 2011 5:42 AM
>To: linux-wireless@vger.kernel.org
>Subject: [iwlagn] System crash on dell e6420 using iwlagn from kernel-git
>
>Hi everyone,
>
>I'm currently testing out the git repository of the linux kernel.
>Unfortunately my system (Gentoo) always crashes shortly after the
>Networkmanager service is started. Not starting the service or using the radio
>killswitch is the only possibility to get the system up. I already tested versions
>0.8.4 and 0.9rc3 of Networkmanager resulting in the same error. This behavior
>came up with using the git-Version of the kernel whereas it was working in
>the 3.0.x releases.
>The really bad news is that I cannot send a detailed trace with this message as
>the relevant parts of the log message are gone due the following hardreset.
>But luckily once a trace remained, which is from the older rc1 but still
>describing the same problem. Unfortunately no debugging symbols were
>active when this trace was generated.
>I've also attached some information about my system.
>I hope you can help me out. Thanks.
>
>Best regards,
>Alexander Diewald
>--
>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the
>body of a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html
