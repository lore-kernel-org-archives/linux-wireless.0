Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42010 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbYFZDk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 23:40:28 -0400
Message-ID: <48630FE7.7060800@lwfinger.net> (sfid-20080626_054033_995067_2811979E)
Date: Wed, 25 Jun 2008 22:41:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id 0x8197/0x8189
References: <779389.39286.qm@web23108.mail.ird.yahoo.com>
In-Reply-To: <779389.39286.qm@web23108.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> --- On Thu, 26/6/08, Matthew Garrett <mjg@redhat.com> wrote:
> <snipped>
>> One thing I noticed is that the 0x8187 USB ID seems to be
>> used for both 
>> plain and b devices, so I suspect we're going to need
>> some more 
>> intelligent probing than just basing it off USB ID. IIRC,
>> the endpoint 
>> descriptions are different?
> 
> This is my /proc/bus/usb/devices entry- anybody who has a 0x8187 which 
> behaves like a 8187b posting theirs? You remember correctly - 8187 
> sends through endpoint 2, 8187b uses 4,5,6,7 and 12 (0x0c). 
> ----------
> T:  Bus=01 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=0bda ProdID=8197 Rev= 2.00
> S:  Manufacturer=Manufacturer_Realtek
> S:  Product=RTL8187B_WLAN_Adapter 
> S:  SerialNumber=<masked>
> C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 9 Cls=ff(vend.) Sub=ff Prot=ff Driver=rtl8187
> E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

My device doesn't show up in /proc, but 
/sys/bus/usb/devices/1-5/product shows it to have the same Product 
string as yours, with a ProdID of 8187.

Does anyone have an 8187b with an ProdID of 0x8187 and a Product 
string that does not say 8187B?

Larry
