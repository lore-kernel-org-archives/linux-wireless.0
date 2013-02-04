Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f179.google.com ([209.85.213.179]:45757 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab3BDX1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 18:27:02 -0500
Received: by mail-ye0-f179.google.com with SMTP id m4so1694406yen.24
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 15:27:01 -0800 (PST)
Message-ID: <511043C0.2020405@gmail.com> (sfid-20130205_002709_697124_79CB15AA)
Date: Tue, 05 Feb 2013 00:26:56 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Thomas Rosenkranz <tom.rosary@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
In-Reply-To: <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2013 12:00 AM, Thomas Rosenkranz wrote:

> btw. if I do:
> $ sudo modprobe -r 8192cu
> the system crashes

> [  183.369324] rtw driver version=v3.4.4_xxxx.20120730

That release is a bit old. Try:
ftp://WebUser:wK9xBuD5@208.70.202.220/cn/wlan/RTL8192xC_USB_linux_v3.4.4_4749.20121105.zip
