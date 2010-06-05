Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snt0-omc2-s38.snt0.hotmail.com ([65.55.90.113]:31592 "EHLO
	snt0-omc2-s38.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933775Ab0FEXnS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 19:43:18 -0400
Message-ID: <SNT144-w576DCA1E748A7C631A1B77DFD30@phx.gbl>
From: Jason Dravet <dravet@hotmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] add support for Dell WLA3310 USB card
Date: Sat, 5 Jun 2010 18:43:17 -0500
In-Reply-To: <4C0AABA8.9010401@lwfinger.net>
References: <SNT144-w4640D712F57F1472EF0A16DFD30@phx.gbl>,<4C0AABA8.9010401@lwfinger.net>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On 06/05/2010 02:55 PM, Larry Finger wrote:
> On 06/05/2010 02:04 PM, Jason Dravet wrote:
>>
>> The Dell WLA3310 USB wireless card has a Z-Com XG-705A chipset that p54 supports with this patch. You also have to get the firmware from
>> http://wireless.kernel.org/en/users/Drivers/p54
>> download 2.13.24.0.lm87.arm (USB 2nd generation (ISL3887)), rename it to
>> isl3887usb and put it in /lib/firmware.
>>
>> The only problem I see is the LED light goes on when I plug the card in and it goes out when I get a dhcp address (dhclient). The LED doesn't flicker when I ping the router either. The other funny thing it has two LEDs, one on top and one on the bottom. It appears they do the same thing i.e. they are both on or both off.
>>
>> Please consider applying for 2.6.35 and stable depending on if you can distribute the firmware. If you need anything else please let me know.
>>
>> Thanks,
>> Jason Dravet
>>
>> Signed-off-by: Jason Dravet 
>> Tested-by: Richard Gregory Tillmore 
>>
>> diff -c p54usb2.c p54usb.c>wla3310.patch
>>
>> *** p54usb2.c Fri Jun 4 21:54:16 2010
>> --- p54usb.c Fri Jun 4 21:54:06 2010
>> ***************
>> *** 82,87 ****
>> --- 82,88 ----
>> {USB_DEVICE(0x2001, 0x3704)}, /* DLink DWL-G122 rev A2 */
>> {USB_DEVICE(0x413c, 0x8102)}, /* Spinnaker DUT */
>> {USB_DEVICE(0x413c, 0x8104)}, /* Cohiba Proto board */
>> + {USB_DEVICE(0x413c, 0x5513)}, /* Dell WLA3310 USB Wireless Adapter */
>> {}
>> };
>
> Thanks for looking to this, but you need read
> Documentation/SubmittingPatches and follow the guidelines, otherwise you
> cause considerable extra work for John Linville.
>
> This time, I will reformat the patch for you.
>
> Larry
 
Thank you Larry.  I appreciate it.  I will RTFM for next time.  How is the firmware issue going to be solved?
 
Thanks,
Jason 		 	   		  
_________________________________________________________________
Hotmail has tools for the New Busy. Search, chat and e-mail from your inbox.
http://www.windowslive.com/campaign/thenewbusy?ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_1