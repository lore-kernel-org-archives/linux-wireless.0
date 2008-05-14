Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:32808 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753491AbYENDip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 23:38:45 -0400
Message-ID: <482A5D2C.7020600@rogers.com> (sfid-20080514_053852_049255_E5ACA5C3)
Date: Tue, 13 May 2008 23:31:56 -0400
From: Fred Odendaal <freshshelf@rogers.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver for WUSB11 v.26 wireless adapter doesn't work
 for kernels newer than 2.6.24.3-12.fc8
References: <4820FFCD.7060905@rogers.com> <1210590665.11848.15.camel@dv>
In-Reply-To: <1210590665.11848.15.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Pavel,

I installed Milan's patches (all 8 of them) and it's still broken. I 
realize that it's nice to have smaller patches for code reviews, but for 
testing it would be a lot easier to have one giant patch.

I'm fairly certain I did the compilation and installation correctly as I 
see 
/lib/modules/2.6.24.5-85.fc8/updates/drivers/net/wireless/at76_usb.ko 
with today's date.

Is there anyway to get the driver to log messages as it's running? I 
noticed that "printk" is used a lot. Where would those messages go?

regards,
Fred Odendaal



Pavel Roskin wrote:
> On Tue, 2008-05-06 at 21:03 -0400, Fred Odendaal wrote:
>   
>> There is a bug report for this here: 
>> https://bugzilla.redhat.com/show_bug.cgi?id=438606
>>
>> Essentially, this driver used to work, but no longer does. The driver 
>> doesn't seem to be able to communicate signal level and link quality.
>>
>> If someone needs me to test a fix for this, or to try test loads I'm 
>> willing to help.
>>     
>
> It's a known problem.  There are some patches by Milan Plzik in
> at76c503a-develop@lists.berlios.de that may help, but they need to be
> reviewed and tested.
>
>   

