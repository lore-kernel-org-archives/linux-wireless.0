Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ukl.yahoo.com ([217.146.182.226]:35834 "HELO
	nm5.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758199Ab1BLEZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 23:25:53 -0500
Message-ID: <4D560BCC.7070104@users.sourceforge.net>
Date: Sat, 12 Feb 2011 04:25:48 +0000
From: Hin-Tak Leung <htl10@users.sourceforge.net>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Vinicius Piccoli <viniciuspiccoli@gmail.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org
Subject: Re: REALTEK 8187SE
References: <AANLkTin+i0uSqBXNXNfUpMVjwavNAPmPuWVJ1jOHh9D7@mail.gmail.com> <4D55FC96.50305@lwfinger.net>
In-Reply-To: <4D55FC96.50305@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On 02/11/2011 08:44 PM, Vinicius Piccoli wrote:
>> Dear Friends
>>
>> I'm newbee in UBUNTU I have install 10.1 in my netbook, I have a 
>> realteck 8187SE,
>> but can not make the wireless work, do you guys have a driver of
>> sofwarecontroler for it?
>>
>> The LAN is working fine!
> 
> There is a driver in drivers/staging that has been there for quite a 
> while. I'm not sure what kernel it first appeared in, but I know it is 
> in 2.6.34. If Ubuntu does not enable it, then you will have either 
> change distros, or build your own kernel.
> 
> Larry
> 

According to wireless-testing's log, the first kernel which a version of the 
8187se staging driver is included is 2.6.29 .

The 8187se staging driver is essentially the same as the Realtek rtl8187se 
vendor driver which is available as a standard-alone download (i.e. without the 
rest of the kernel source tree, and build-able as such) from a variety of 
on-line places, not least Ubuntu's laundpad as attachment to a few 
bug/enhancement reports.

AFAIK, the 8187se is quite a different beast and uses the PCI interface and 
closer to the 8180/8185(?), rather than the USB interface like the 8187L/8187B.

However, I found a few issues concerning your e-mail problematic:

1) You have obviously worked out that the 3 of us are the current 8187/8187B 
maintainers, which suggests that you are not as newbie as you like us to believe 
- all the 8187se info are available in the linux-wireless mailing list archive, 
really, and you could have found the same info we gave you by similiar methods 
you found our e-mail addresses. I am not your friend. I really do not know you.

2) I can't speak for the others, but I generally do not like people e-mailing me 
  privately (i.e. without CC'ing a relevant mailing list) on reasonably widely 
applicable open-source issues. A private answer to a private question benefit 
nobody else. That's the purpose of having mailing lists and mailing list 
archives are for. If I want to receive e-mails from random unknown individuals 
privately, I would charge them for it.

Hin-Tak
