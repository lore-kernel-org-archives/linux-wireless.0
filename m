Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50981 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab3BETDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 14:03:43 -0500
Received: by mail-ob0-f172.google.com with SMTP id tb18so551849obb.17
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 11:03:42 -0800 (PST)
Message-ID: <5111578D.7060300@lwfinger.net> (sfid-20130205_200346_941719_016CCA80)
Date: Tue, 05 Feb 2013 13:03:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thomas Rosenkranz <tom.rosary@googlemail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com> <511043C0.2020405@gmail.com> <CAOAX8-kFtWuwEvz9v7hBzOwtohJx0NezrDHC0iVwXF29YYSCgQ@mail.gmail.com>
In-Reply-To: <CAOAX8-kFtWuwEvz9v7hBzOwtohJx0NezrDHC0iVwXF29YYSCgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2013 12:30 PM, Thomas Rosenkranz wrote:
> your link didn't work, got driver from realtek homepage
>
> tommy@Tommy-AIO:~$ modinfo 8192cu | egrep 'versi|filen|819'
> filename:       /lib/modules/3.2.0-37-generic/kernel/drivers/net/wireless/8192cu.ko
> version:        v3.4.4_4749.20121105
> srcversion:     657E53E8FE213B566819C54
> alias:          usb:v0BDAp8191d*dc*dsc*dp*ic*isc*ip*
> vermagic:       3.2.0-37-generic SMP mod_unload modversions
> parm:           rtw_chip_version:int
>
> still the crash after trying to removethe modul

Sorry, but I do not debug the vendor drivers.

Larry


