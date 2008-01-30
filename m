Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43296 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761362AbYA3W5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 17:57:40 -0500
Date: Wed, 30 Jan 2008 23:57:38 +0100
From: Sebastian Siewior <ipw+2200@ml.breakpoint.cc>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net
Subject: Re: ipw2200 stalls on high load
Message-ID: <20080130225738.GB2648@Chamillionaire.breakpoint.cc> (sfid-20080130_225745_380211_26BD5C17)
References: <20080126132939.GA22630@Chamillionaire.breakpoint.cc> <D936D925018D154694D8A362EEB0892003800B1B@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <D936D925018D154694D8A362EEB0892003800B1B@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Chatre, Reinette | 2008-01-28 10:40:16 [-0800]:

>On ,Sebastian Siewior wrote:
>
>> Hello,
>> 
>> my wireless connection stalls after like 5 seconds once the
>> downloading performance passes around 600 KiB/sec. I noticed in dmesg
>> the following:
>>> ipw2200: Firmware error detected.  Restarting.
>
>Could you please submit a bug at http://www.bughost.org to enable us to
>track this problem? 
Sure. #1487 looks very close. The firmware version seems to be different
as well as the "the driver messsage". Do you want me to open a new one or
should I follow-up?

>Thank you 
>
>Reinette
>
Regards,
Sebastian
