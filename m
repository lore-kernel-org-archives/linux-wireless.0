Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:32968 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYHRXmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 19:42:09 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1803724fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 16:42:07 -0700 (PDT)
Message-ID: <1ba2fa240808181642h61fb2d74ja96dd3860fb5d4e6@mail.gmail.com> (sfid-20080819_014214_265698_ED3AB90F)
Date: Tue, 19 Aug 2008 02:42:07 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Yousaf Jindal" <yousaf.jindal@pi.edu.pk>,
	"Will Simoneau" <simoneau@ele.uri.edu>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Cc: ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <e700089d0808180943m1bc403d4v3ee578a81e2d96cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com>
	 <e700089d0808160326k337cec2dm65271b38812a4263@mail.gmail.com>
	 <1ba2fa240808180112l284086f4x64168d994743398@mail.gmail.com>
	 <e700089d0808180315s4851ed0fqea6b64c83eb570f@mail.gmail.com>
	 <1ba2fa240808180547md32b43au7b1beaccab1f5fd6@mail.gmail.com>
	 <e700089d0808180943m1bc403d4v3ee578a81e2d96cf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 18, 2008 at 7:43 PM, Yousaf Jindal <yousaf.jindal@pi.edu.pk> wrote:
> On Mon, Aug 18, 2008 at 8:47 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Mon, Aug 18, 2008 at 1:15 PM, Yousaf Jindal <yousaf.jindal@pi.edu.pk> wrote:
>>> On Mon, Aug 18, 2008 at 4:12 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>>>>
>>>> Please try attached patch (not sure it will help tough)
>>>> I also will need output of
>>>>  >cat /sys/class/net/wlan0/devices/version
>>>>
>>>>
>>>> Thanks
>>>> Tomas
>>>
>>> $ cat /sys/class/net/wlan0/device/version
>>> fw not loaded
>>> EEPROM version: 0x11e
>>>
>> Where did you get this card from?
>> Thanks
>> Tomas
>>
>
> The card is included with Asus M50Vm-B2 laptops. ( e.g.,
> http://www.newegg.com/Product/Product.aspx?Item=N82E16834220344 )
>
The eeprom looks a bit off it should be 0x11f but it should not have
this affect.
It will take a while till I get this Laptop so one more request which
I should  actually start with is to send me your kernel config file.
(personally I prefer attachment instead of inline mail)

Thanks
Tomas
