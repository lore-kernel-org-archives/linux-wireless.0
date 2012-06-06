Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57938 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2FFEBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 00:01:44 -0400
Received: by ghrr11 with SMTP id r11so4953063ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 21:01:43 -0700 (PDT)
Message-ID: <4FCED623.6050600@lwfinger.net> (sfid-20120606_060152_761893_E6C4DF7F)
Date: Tue, 05 Jun 2012 23:01:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ouyang <ilhebe999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: usb.c
References: <loom.20120605T215520-645@post.gmane.org> <4FCE67CA.2020502@lwfinger.net> <loom.20120605T221743-446@post.gmane.org>
In-Reply-To: <loom.20120605T221743-446@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2012 03:23 PM, Ouyang wrote:

> Thank you so much for the reply. I am so appreciated.
>
> I am still a little confused. Would you please set an example for
> drivers/net/wireless/rtlwifi/usb.c ?

That file contains the USB-specific low-level routines for the driver used by 
the RTL8188CU devices built by Realtek. If you want to know what that file does, 
read the comments.

Larry
