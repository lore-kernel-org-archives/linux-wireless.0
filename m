Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55460 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1EGFms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 01:42:48 -0400
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlagn: crash when unloading the module
References: <87iptsgk5y.fsf@purkki.adurom.net>
	<20110504132602.GA2183@redhat.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 07 May 2011 08:42:46 +0300
In-Reply-To: <20110504132602.GA2183@redhat.com> (Stanislaw Gruszka's message of "Wed\, 4 May 2011 15\:26\:03 +0200")
Message-ID: <87pqnvf4mh.fsf@purkki.adurom.net> (sfid-20110507_074250_487255_FAC6BC3D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Tue, May 03, 2011 at 01:20:25PM +0300, Kalle Valo wrote:
>> I noticed today a crash when removing iwlagn module. I can see the
>> crash everytime on my lenovo x201 (x86 64bit, i5) with this wireless
>> chip:
>> 
>> [   19.484551] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R)
>> Ultimate-N 6300 AGN, REV=0x74

[...]

> We can not exclude iwlagn problem only triggered with intel iommu,
> because problem does not happen with other modules, or does it?

I have only seen the crash with iwlagn. But I have to admit that I
haven't tried to unload modules that much.

> Except test patch pointed by Johannes, I suggest turning on
> CONFIG_DMA_API_DEBUG

I already had this on and I haven't noticed anything wrong.

> and test with intel_iommu=on and intel_iommu=off.

I'll skip these as David's patch seem to already help.

-- 
Kalle Valo
