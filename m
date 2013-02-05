Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:44895 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3BESdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 13:33:32 -0500
Received: by mail-qe0-f50.google.com with SMTP id 7so240760qea.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 10:33:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOAX8-kFtWuwEvz9v7hBzOwtohJx0NezrDHC0iVwXF29YYSCgQ@mail.gmail.com>
References: <51102B22.20702@gmail.com>
	<CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
	<511043C0.2020405@gmail.com>
	<CAOAX8-kFtWuwEvz9v7hBzOwtohJx0NezrDHC0iVwXF29YYSCgQ@mail.gmail.com>
Date: Tue, 5 Feb 2013 19:33:31 +0100
Message-ID: <CAOAX8-naxW_YqOUw-Xw3zP_F23yC=eeZntZ=JvZrNv9wqtepiA@mail.gmail.com> (sfid-20130205_193336_324894_59126967)
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
From: Thomas Rosenkranz <tom.rosary@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 your link didn't work, got driver from realtek homepage


 tommy@Tommy-AIO:~$ modinfo 8192cu | egrep 'versi|filen|819'
 filename:
 /lib/modules/3.2.0-37-generic/kernel/drivers/net/wireless/8192cu.ko
 version:        v3.4.4_4749.20121105
 srcversion:     657E53E8FE213B566819C54

 alias:          usb:v0BDAp8191d*dc*dsc*dp*ic*isc*ip*
 vermagic:       3.2.0-37-generic SMP mod_unload modversions
 parm:           rtw_chip_version:int

 still the crash after trying to remove the modul


>
> 2013/2/5 Xose Vazquez Perez <xose.vazquez@gmail.com>
>>
>> On 02/05/2013 12:00 AM, Thomas Rosenkranz wrote:
>>
>> > btw. if I do:
>> > $ sudo modprobe -r 8192cu
>> > the system crashes
>>
>> > [  183.369324] rtw driver version=v3.4.4_xxxx.20120730
>>
>> That release is a bit old. Try:
>>
>> ftp://WebUser:wK9xBuD5@208.70.202.220/cn/wlan/RTL8192xC_USB_linux_v3.4.4_4749.20121105.zip
>
>
