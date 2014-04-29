Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cethen.legt.fr ([92.243.2.98]:60811 "EHLO cethen.legt.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaD2Nye (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 09:54:34 -0400
From: Vincent Legout <vincent@legout.info>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Driver for RTL8192EE
References: <535E6AF2.1000608@lwfinger.net>
Date: Tue, 29 Apr 2014 09:48:41 -0400
In-Reply-To: <535E6AF2.1000608@lwfinger.net> (Larry Finger's message of "Mon,
	28 Apr 2014 09:51:30 -0500")
Message-ID: <87eh0gfdqe.fsf@cecht.legt.fr> (sfid-20140429_155437_833401_BF044C5F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Larry Finger <Larry.Finger@lwfinger.net> writes:

> There are apparently a lot of Lenovo T440s laptops in the wild. In
> fact, I have had enough requests for the patches to add driver r8192ee
> to the staging tree, that I am making it available on my FTP site.
>
> To obtain this driver, download the following two files:
>
> http://www.lwfinger.com/realtek_drivers/0001-staging-r8192ee-Add-new-driver.patch
> http://www.lwfinger.com/realtek_drivers/0002-staging-r8192ee-Add-new-driver.patch
>
> Use these two files, in turn, to modify the standard 3.14.X or
> 3.15.0-rcX code for this device. Then build a custom kernel for your
> computer.
>
> I am presently testing a modified version of this code that uses the
> standard rtlwifi structure, and hope to have it ready for submission
> in time for kernel 3.16.

Thank you for the patch. I applied it on top of the 3.14 kernel
available in Debian experimental and it seems to work just fine on my
Lenovo T440s running Debian testing.

Thanks,
Vincent
