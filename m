Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:47293 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYFLOTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 10:19:22 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2500089fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 07:19:18 -0700 (PDT)
Message-ID: <48513063.5020703@gmail.com> (sfid-20080612_161929_042244_CF945B52)
Date: Thu, 12 Jun 2008 17:19:15 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
References: <484FEA26.1040305@gmail.com> <1213241315.7814.696.camel@debian.sh.intel.com> <20080612135936.GA5031@tuxdriver.com>
In-Reply-To: <20080612135936.GA5031@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Thu, Jun 12, 2008 at 11:28:35AM +0800, Zhu Yi wrote:
> 
>> I don't understand why "disable_hw_scan=1" works for you. Can you also
>> attach the dmesg for it?
> 
> How does the hardware scan differ from what mac80211 does when
> scanning?  I still see a lot of mysterious iwlwifi (especially iwl3945)
> problems in Fedora that seem to disappear with disable_hw_scan=1.
> 
> Honestly I'm tempted to change it to "enable_hw_scan" instead...
> 
> John

Exactly.

Although hardware scanning is better, until it is fixed it
is better to disable it, so at least users will get working wireless out
of box.

Best regards,
	Maxim levitsky

PS: intel devs, please look at that, it looks like your firmware has a 
bug, so please try to fix it.


