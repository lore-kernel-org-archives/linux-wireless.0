Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web15808.mail.cnb.yahoo.com ([202.165.102.88]:31155 "HELO
	web15808.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751907AbZG2JYL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 05:24:11 -0400
Message-ID: <109708.86209.qm@web15808.mail.cnb.yahoo.com>
Date: Wed, 29 Jul 2009 17:24:09 +0800 (CST)
From: gu gu <guatsheng@yahoo.com.cn>
Subject: The problem of driver of rtl8187 wireless card
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Dear Sir,
     Rencently,I do a job to transplant a wireless wifi-card connected by the USB,which was designed baseing the chip rtl8187 for ARM board.But in the process i have some trouble in writing the driver programe.
     My linux kernel is Version-2.6.25.10,It is true that the kernel have the driver for the chip rtl8187 .When I connected the wifi card through the USB port ,the kernel can recoganize the card "Manufacturer_Realtek_RTL8187",So it's sure that the driver of RTL8187 is no problem.But when I ping it to the AP,the missing of datapackets and the delay are both terrible.and more , there is nothing accepted by the wireless router when i typed the "ping".
so i think there is some bug exist in the driver for RTL8187 of kernel ,isn't it? (ps: I have set several parameter,such essid ,IP address...) 
  So I download a "compat-wireless-2.6-old" packet.following the " Readme",i added the KLIB & KLIB_BUILD in the Makefile and "make" it.It is well to generate  some modules with the typing".o"! but has not compiled the file rtl8187 or generated a "rtl8187.o". 
and so i wanna to know how to solve this problem. i need some help from u,
Thank you for your attention!

Gu  C.L.


      ___________________________________________________________ 
  好玩贺卡等你发，邮箱贺卡全新上线！ 
http://card.mail.cn.yahoo.com/
