Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16480 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1HXOIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:08:43 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Alexander Diewald <alex@diewald.cc>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Date: Wed, 24 Aug 2011 07:08:36 -0700
Subject: RE: [iwlagn] System crash on dell e6420 using iwlagn from
 kernel-git
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501998B9CD3@orsmsx506.amr.corp.intel.com> (sfid-20110824_160846_216922_0DD89C45)
References: <2EBB96D0C3577D479C54D1243926388D07AE5FFE@mail.ecs-exchange.de>
In-Reply-To: <2EBB96D0C3577D479C54D1243926388D07AE5FFE@mail.ecs-exchange.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alex,

I am on vacation now and I will asking the right people in the team to look into this problem and get back to you.

Thanks
Wey

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Alexander Diewald
Sent: Wednesday, August 24, 2011 5:42 AM
To: linux-wireless@vger.kernel.org
Subject: [iwlagn] System crash on dell e6420 using iwlagn from kernel-git

Hi everyone,

I'm currently testing out the git repository of the linux kernel.
Unfortunately my system (Gentoo) always crashes shortly after the Networkmanager service is started. Not starting the service or using the radio killswitch is the only possibility to get the system up. I already tested versions 0.8.4 and 0.9rc3 of Networkmanager resulting in the same error. This behavior came up with using the git-Version of the kernel whereas it was working in the 3.0.x releases.
The really bad news is that I cannot send a detailed trace with this message as the relevant parts of the log message are gone due the following hardreset. But luckily once a trace remained, which is from the older rc1 but still describing the same problem. Unfortunately no debugging symbols were active when this trace was generated.
I've also attached some information about my system.
I hope you can help me out. Thanks.

Best regards,
Alexander Diewald
