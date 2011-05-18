Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10037 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294Ab1ERR7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 13:59:12 -0400
Subject: Re: iwlagn: 2.6.38.6 memory corruption when unloading module?
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stevie Trujillo <stevie.trujillo@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201105181821.49508.stevie.trujillo@gmail.com>
References: <201105181821.49508.stevie.trujillo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 10:33:17 -0700
Message-ID: <1305739997.14995.285.camel@wwguy-huron> (sfid-20110518_195915_545287_8165A671)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stevie,
On Wed, 2011-05-18 at 09:21 -0700, Stevie Trujillo wrote:
> Hello,
> 
> I have a Dell-XPS 15 with a Intel(R) Centrino(R) Wireless-N 1030 BGN card.
> Doing modprobe -r iwlagn; modprobe iwlagn makes my kernel crash (sometimes I 
> have to repeat it).
> I managed to get a backtrace (the file "dmesg-kexec.txt" attached) with the 
> advice of Milton Miller.
> I also tried to boot with slub_debug=FZ (not exactly sure what that does) - 
> dmesg attached in "dmesg-slub_debug.txt".

> --
Thank you for the data, we are look into this issue and try to
re-produce the problem here. I will update you on our finding.

Could you create a bug in  http://bugzilla.intellinuxwireless.org/ with
the information?

Thanks
Wey


