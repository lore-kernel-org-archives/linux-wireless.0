Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:56633 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYKYC0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 21:26:07 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1217317nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 18:26:05 -0800 (PST)
Message-ID: <492B623E.5030202@gmail.com> (sfid-20081125_032612_870861_48702D7C)
Date: Mon, 24 Nov 2008 21:26:06 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless-regdb: flaw in general functionality
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla>	 <1227568883.28878.15.camel@dv> <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com>
In-Reply-To: <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Nov 24, 2008 at 3:21 PM, Pavel Roskin <proski@gnu.org> wrote:
>   
>> On Mon, 2008-11-24 at 15:12 -0800, Luis R. Rodriguez wrote:
>>
>>     
>>> Your point about not being able to listen is a good one, and a patch to
>>> update the the US in consideration of part 15 rules would be
>>> appreciated. Keep in mind we have flags for such things:
>>>
>>>   -Passive scan
>>>   -No-IBSS
>>>
>>> We should probably rename no-ibss to no-beaconing though as that is the
>>> real meaning inention behind it.
>>>       
>> Maybe you mean no-transmit?
>>     
>
> Yeah sure, that seems to make more sense.
>
>   
I'm all for adding it to crda as no-transmit but, is that a valid flag?  
Also, how well does it work?  From a monitor mode interface you can 
inject raw packets out of the interface.  Would just adding 
"no-transmit" into the crda line work?  I certainly don't see this in 
the crda code anywhere, nor in the definition of regdb file.  I presume 
this has to be added?

Thanks,
Rick Farina




>  Luis
>
>   

