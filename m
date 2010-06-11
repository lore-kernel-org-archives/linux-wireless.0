Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56118 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0FKUIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 16:08:48 -0400
Received: by vws17 with SMTP id 17so1521530vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jun 2010 13:08:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinpYdb9Q_AEdUc7gvEIcxZoCFyVaKMIi6c_Sf9n@mail.gmail.com>
References: <AANLkTinpYdb9Q_AEdUc7gvEIcxZoCFyVaKMIi6c_Sf9n@mail.gmail.com>
From: Assim Deodia <assim.deodia@gmail.com>
Date: Sat, 12 Jun 2010 01:38:21 +0530
Message-ID: <AANLkTinPM1byJy-y8GChXbAdYQuCvgiQRISWfmBRKoJu@mail.gmail.com>
Subject: Re: no eth0 on using libertas_tf + F11 on OLPC XO-1
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I am having some issues loading libertas_tf on XO-1 with kernel 2.6.31.

1) after unloading libertas and usb8xxx modules when i modprobe
libertas_tf module eth0 (wireless interface) disappears. and instead
wmaster0 appears. but iwconfig show  wmaster0 does not have wireless
extensions. lsmod shows libertas_tf and libertas_tf_usb module loaded.
No error in system logs. no error by modprobe. but no wireless
interface. Do i have to pass any parameter while loading libertas_tf?
I have also tried installing all the firmware versions from
http://dev.laptop.org/pub/firmware/libertas/thinfirm/ just to be sure.
I have installed the kernel after build its RPM
(http://dev.laptop.org/~assim/kernel_rpms/) on XO itself.

2) I also tried blacklisting libertas and usb8xxx modules but still
they are loading at boot time. again no error in logs.

I am stuck as i am not getting any error message at all.

-- 
Assim Deodia
