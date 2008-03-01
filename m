Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:42671 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbYCATVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 14:21:18 -0500
Message-ID: <47C9ACA9.70800@gmail.com> (sfid-20080301_192127_416353_4D6652E9)
Date: Sat, 01 Mar 2008 12:21:13 -0700
From: Larry Finger <Larry.Finger@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Wu <flamingice@sourmilk.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problems with RTL8187 USB device
References: <47C49D21.1030905@lwfinger.net> <20080227010732.GB3066@tuxdriver.com> <47C4F4B4.7030300@gmail.com>
In-Reply-To: <47C4F4B4.7030300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> If I can give you any help with the patch, please let me know. In about
> another week, I will be forced to use Windows to access the Internet
> (Yuck!!).
>   
Since the previous message, I have made some progress. I downloaded the
Realtek driver for the RTL8187b and modified it to build under
2.6.25-rcX. It will report nearby AP's and associate even though the
signal is weak. It fails authentication as it enters some false WEP key
no matter what encryption is used.

I figured out how to make using Windows palatable. I installed
VirtualBox under Windows and created an openSUSE 10.3 virtual machine. I
can use Windows to connect to the wi-fi network, and then the virtual
machine bridges through to the Internet. It is a lot ad-hoc, but it
works. This kludge will work until I can get my laptop repaired.

Larry

