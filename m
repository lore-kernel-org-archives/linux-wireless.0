Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:37351 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbYFLMNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 08:13:46 -0400
Received: by wx-out-0506.google.com with SMTP id h29so1407585wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 05:13:45 -0700 (PDT)
Message-ID: <485112F4.7020207@gmail.com> (sfid-20080612_141352_563894_924D808D)
Date: Thu, 12 Jun 2008 15:13:40 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [BUG] iwlwifi 3945 works only with disable_hw_scan=1
References: <484FEA26.1040305@gmail.com> <1213241315.7814.696.camel@debian.sh.intel.com>
In-Reply-To: <1213241315.7814.696.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> On Wed, 2008-06-11 at 18:07 +0300, Maxim Levitsky wrote:
>> [   87.270433] wlan0: Initial auth_alg=0
>> [   87.270433] wlan0: authenticate with AP 00:1b:9e:d8:77:02
>> [   87.273477] wlan0: RX authentication from 00:1b:9e:d8:77:02 (alg=0
>> transaction=2 status=0)
>> [   87.273477] wlan0: authenticated
>> [   87.273477] wlan0: associate with AP 00:1b:9e:d8:77:02
>> [   87.275823] wlan0: RX AssocResp from 00:1b:9e:d8:77:02 (capab=0x411
>> status=0 aid=1)
>> [   87.275823] wlan0: associated
>> [   87.275823] wlan0: switched to short barker preamble
>> (BSSID=00:1b:9e:d8:77:02)
>> [   87.276185] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [   92.713277] APIC error on CPU0: 40(40)
>> [   97.885625] wlan0: no IPv6 routers present
>> [  111.766658] wlan0: no IPv6 routers present
>> [  112.121332] APIC error on CPU0: 40(40)
>> [  144.876825] APIC error on CPU0: 40(40)
>> [  158.676958] APIC error on CPU0: 40(40)
>> [  212.915533] APIC error on CPU0: 40(40)
>> [  290.079923] APIC error on CPU0: 40(40)
>> [  290.632507] APIC error on CPU0: 40(40)
>> [  296.557068] APIC error on CPU0: 40(40)
>> [  303.989147] APIC error on CPU0: 40(40)
>> [  305.782793] APIC error on CPU0: 40(40)
>> [  307.150566] APIC error on CPU0: 40(40)
>> [  310.248346] APIC error on CPU0: 40(40)
>> [  310.657006] APIC error on CPU0: 40(40)
>> [  311.453595] APIC error on CPU0: 40(40)
>> [  317.468024] APIC error on CPU0: 40(40)
>> [  321.284080] APIC error on CPU0: 40(40)
>> [  328.179853] APIC error on CPU0: 40(40)
>> [  330.127038] APIC error on CPU0: 40(40)
>> [  332.437435] APIC error on CPU0: 40(40)
>> [  335.326931] APIC error on CPU0: 40(40)
>> [  335.881538] APIC error on CPU0: 40(40)
>> [  337.790227] APIC error on CPU0: 40(40)
>> [  368.373446] APIC error on CPU0: 40(40)
>> [  369.809138] APIC error on CPU0: 40(40)
>> [  374.289855] APIC error on CPU0: 40(40)
>> [  375.768238] APIC error on CPU0: 40(40)
>> [  382.440748] APIC error on CPU0: 40(40)
>> [  383.159443] APIC error on CPU0: 40(40)
>> [  383.529522] APIC error on CPU0: 40(40)
>> [  383.906913] APIC error on CPU0: 40(40)
>> [  384.356990] APIC error on CPU0: 40(40)
>> [  384.610941] APIC error on CPU0: 40(40)
>> [  386.305185] APIC error on CPU0: 40(40)
>> [  386.935949] APIC error on CPU0: 40(40)
>> [  390.071741] APIC error on CPU0: 40(40)
>> [  390.403979] APIC error on CPU0: 40(40)
>> [  391.114519] APIC error on CPU0: 40(40)
>> [  391.528138] APIC error on CPU0: 40(40)
>> [  403.677688] APIC error on CPU0: 40(40)
>> [  404.140181] APIC error on CPU0: 40(40)
>> [  406.270920] APIC error on CPU0: 40(40)
>> [  406.927867] APIC error on CPU0: 40(40)
>> [  418.880757] APIC error on CPU0: 40(40)
>> [  419.235211] APIC error on CPU0: 40(40)
>> [  437.974455] APIC error on CPU0: 40(40)
>> [  438.193878] APIC error on CPU0: 40(40)
>> [  443.974790] APIC error on CPU0: 40(40)
>> [  444.177027] APIC error on CPU0: 40(40)
>> [  479.469645] APIC error on CPU0: 40(40)
>> [  479.720979] APIC error on CPU0: 40(40)
>> [  497.925734] APIC error on CPU0: 40(40)
>> [  498.202985] APIC error on CPU0: 40(40)
>> [  526.922424] APIC error on CPU0: 40(40)
>> [  527.607409] APIC error on CPU0: 40(40)
>> [  715.960235] APIC error on CPU0: 40(40)
>> [  716.232556] APIC error on CPU0: 40(40)
>> [  753.480442] APIC error on CPU0: 40(40)
>> [  753.820830] APIC error on CPU0: 40(40)
>> [  774.693756] APIC error on CPU0: 40(40)
>> [  774.867494] APIC error on CPU0: 40(40)
>> [  815.787137] APIC error on CPU0: 40(40)
>> [  816.308363] APIC error on CPU0: 40(40)
>> [  841.546917] APIC error on CPU0: 40(40)
>> [  842.082173] APIC error on CPU0: 40(40)
>> [  847.758887] ACPI: PCI interrupt for device 0000:06:00.0 disabled
> 
> It looks the association is succeeded. But 5 minutes later it got an
> APIC error. Then I found this error is with lot of devices in your
> system. Not sure about what caused this. Can you please try disable MSI
> with boot param pci=nomsi?
> 
> I don't understand why "disable_hw_scan=1" works for you. Can you also
> attach the dmesg for it?
> 
> Thanks,
> -yi
> 

Forgot to tell you that you can ignore the APIC error.

I tested and I know that this error happens always, when CPU fan speed 
change, so I guess this is unrelated)

Best regards,
	Maxim levitsky
