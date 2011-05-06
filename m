Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53952 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1EFELw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 00:11:52 -0400
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: crash when unloading the module
References: <87iptsgk5y.fsf@purkki.adurom.net>
	<1304433727.5744.107.camel@wwguy-ubuntu>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 06 May 2011 07:11:50 +0300
In-Reply-To: <1304433727.5744.107.camel@wwguy-ubuntu> (wwguy's message of "Tue\, 03 May 2011 07\:42\:07 -0700")
Message-ID: <87y62kfoxl.fsf@purkki.adurom.net> (sfid-20110506_061156_496543_D74FCC86)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wwguy <wey-yi.w.guy@intel.com> writes:

> On Tue, 2011-05-03 at 03:20 -0700, Kalle Valo wrote:
>
>> I noticed today a crash when removing iwlagn module. I can see the
>> crash everytime on my lenovo x201 (x86 64bit, i5) with this wireless
>> chip:

[...]

> it is new to me as well, I never see that happen on my system. Could you
> share some more information with me? such as laptop model, kernel
> version, 32 or 64 bits.

This was in my original mail, see above :)

> Also is there any activity while you unload the iwlagn, is it in connect
> state or not? 

wlan0 interface was down.

-- 
Kalle Valo
