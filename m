Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47515 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYKXCe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 21:34:58 -0500
Cc: Mike Kershaw <dragorn@kismetwireless.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <4270E0F0-BE5E-4448-A6B0-2E74113488F6@holtmann.org> (sfid-20081124_033510_665977_1442DBBE)
From: Marcel Holtmann <marcel@holtmann.org>
To: Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1227491716.2548.213.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: iwlagn MAC in deep sleep
Date: Mon, 24 Nov 2008 03:34:53 +0100
References: <20081121193348.GA7373@drd1813.lan> <1227491716.2548.213.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

>> iwlagn: MAC is in deep sleep!
>> pciehp: Card present on Slot(3)
>> iwlagn: MAC is in deep sleep!
>> iwlagn: MAC is in deep sleep!
>> iwlagn: MAC is in deep sleep!
>> iwlagn: MAC is in deep sleep!
>> iwlagn: MAC is in deep sleep!
>> iwlagn: MAC is in deep sleep!
>> iwlagn: MAC is in deep sleep!
>> iwlagn: Unable to init nic
>
> Can you please look for something called vPRO/AMT in your BIOS and try
> to disable it?

what has that to do with it? You need to explain why this should help  
at all. Just randomly enabling/disabling features of your core system  
is not a good debugging method. And even if that makes this go away,  
it is still a bug that needs fixed.

Regards

Marcel

