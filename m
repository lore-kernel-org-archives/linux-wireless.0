Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60347 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2DPW2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:28:34 -0400
Received: by iagz16 with SMTP id z16so8029172iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 15:28:34 -0700 (PDT)
Message-ID: <4F8C9D0D.6070606@lwfinger.net> (sfid-20120417_002849_460376_844E0FEE)
Date: Mon, 16 Apr 2012 17:28:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jan Simonson <jan@simonson.se>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8192e-pci NIC
References: <1502184.lhzNHmlX61@ymer> <20120409192630.GB26994@tuxdriver.com> <4F835FB9.5020100@lwfinger.net> <3893847.nxaiIbI8jN@ymer>
In-Reply-To: <3893847.nxaiIbI8jN@ymer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2012 10:51 AM, Jan Simonson wrote:
>
> That would be very helpful! I look forward to hear from you again when it's
> available on your ftp site.
>
> Thanks again for helping me with this problem.

As you saw from the copies of E-mails, my problem was in the configuration of my 
kernel. The stand-alone source is available from

http://www.lwfinger.com/realtek/rtl8192e_pci_sa.tar.bz2

Download any unpack that file, cd to rtl8192e_sa and do a 'make' followed by 
'sudo make install'. Your device should then work.

For anyone else reading this thread, this step is needed for Fedora and other 
distros that do not enable staging drivers.

Larry

