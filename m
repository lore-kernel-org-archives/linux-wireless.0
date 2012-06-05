Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55787 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2FEUKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 16:10:54 -0400
Received: by yenm10 with SMTP id m10so4381335yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 13:10:54 -0700 (PDT)
Message-ID: <4FCE67CA.2020502@lwfinger.net> (sfid-20120605_221058_210361_73FE2FF1)
Date: Tue, 05 Jun 2012 15:10:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ouyang <ilhebe999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: usb.c
References: <loom.20120605T215520-645@post.gmane.org>
In-Reply-To: <loom.20120605T215520-645@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2012 02:56 PM, Ouyang wrote:
> Wireless-testing is a kernel about wireless card or something related, but why
> there is a file named usb.c? Is it related to usb? Hope who can answer it to me.
> Thank you so much.

Wireless-testing is a complete tree, thus it has every file that is found in the 
mainline tree. There are a number of files named usb.c. To know what it does, 
you would need to tell what path it is in. In general, a file named usb.c would 
contain the interface between a device and the USB system.

The differences between wireless-testing and mainline are related to the 
development. New material comes through wireless-testing and goes through 
several trees before if is merged into mainline. Usually wireless-testing is 
about 1 version newer than mainline.

Larry

