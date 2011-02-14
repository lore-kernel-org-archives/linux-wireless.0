Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web161619.mail.bf1.yahoo.com ([98.139.211.141]:44172 "HELO
	web161619.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751226Ab1BNSMe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 13:12:34 -0500
Message-ID: <231638.53646.qm@web161619.mail.bf1.yahoo.com>
Date: Mon, 14 Feb 2011 10:12:33 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Build Error Report(zd1211rw)
To: linux-wireless@vger.kernel.org,
	Masahiro Inoue <miyabi.-.inoue@nifty.com>
In-Reply-To: <20110214101925.9EC3.2E210E2F@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for kernels prior to 2.6.29 is currently not available for zd1211rw. Try older compat-wireless version or upgrade your kernel.

Walter.


> The build error occurs by compat-wireless-2011-02-12.
> My kernel is 2.6.27. 
> 
>   CC [M] 
> /home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw/zd_mac.o
> /home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw/zd_mac.c:
> In function 'zd_mac_config_beacon':
> /home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw/zd_mac.c:781:
> error: implicit declaration of function
> 'usb_queue_reset_device'
> make[4]: ***
> [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw/zd_mac.o]
> Error 1
> make[3]: ***
> [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw]
> Error 2
> make[2]: ***
> [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless]
> Error 2
> make[1]: ***
> [_module_/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12]
> Error 2
> make[1]: Leaving directory
> `/usr/src/kernels/2.6.27-67vl5-x86_64'
> make: *** [modules] Error 2



      
