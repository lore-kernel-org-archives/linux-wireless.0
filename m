Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:50662 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYHYHZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 03:25:59 -0400
Received: by nf-out-0910.google.com with SMTP id d3so676795nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 00:25:57 -0700 (PDT)
Message-ID: <1ba2fa240808250025td45df6bs93b87e1e23a37195@mail.gmail.com> (sfid-20080825_092603_729617_A3CAA032)
Date: Mon, 25 Aug 2008 10:25:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Will Simoneau" <simoneau@ele.uri.edu>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Cc: "Yousaf Jindal" <yousaf.jindal@pi.edu.pk>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080825043705.GA16061@ele.uri.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com>
	 <e700089d0808160326k337cec2dm65271b38812a4263@mail.gmail.com>
	 <1ba2fa240808180112l284086f4x64168d994743398@mail.gmail.com>
	 <e700089d0808180315s4851ed0fqea6b64c83eb570f@mail.gmail.com>
	 <1ba2fa240808180547md32b43au7b1beaccab1f5fd6@mail.gmail.com>
	 <e700089d0808180943m1bc403d4v3ee578a81e2d96cf@mail.gmail.com>
	 <1ba2fa240808181642h61fb2d74ja96dd3860fb5d4e6@mail.gmail.com>
	 <20080821073140.GA18961@ele.uri.edu>
	 <20080825043705.GA16061@ele.uri.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 25, 2008 at 7:37 AM, Will Simoneau <simoneau@ele.uri.edu> wrote:
>> > It will take a while till I get this Laptop so one more request which
>> > I should  actually start with is to send me your kernel config file.
>> > (personally I prefer attachment instead of inline mail)
>> >
>> > Thanks
>> > Tomas
>>
>> The patch does not help in my case either. .config attached.
>>
>> # cat /sys/class/net/wlan0/device/version
>> fw not loaded
>> EEPROM version: 0x11f
>
> [snip .config]
>
> I was just playing around with the driver a bit, and I turned on debug
> mode. Somehow, the interface came up and scanning worked - once. It
> hasn't worked again, with debugging both on and off. I have the log
> messages from when it worked, let me know if they might be useful.
>
> I was testing without the additional patch, BTW. Just the vanilla
> version from the git tree, iwl5000 branch.
>
Yes please send it over.
Thanks
Tomas
