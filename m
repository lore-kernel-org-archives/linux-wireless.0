Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:61714 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEDPGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2014 11:06:53 -0400
Received: by mail-ob0-f172.google.com with SMTP id wo20so7444696obc.3
        for <linux-wireless@vger.kernel.org>; Sun, 04 May 2014 08:06:52 -0700 (PDT)
Message-ID: <5366578B.6020501@lwfinger.net> (sfid-20140504_170711_647353_695DD0A8)
Date: Sun, 04 May 2014 10:06:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Lawrence Zhu <lawrencezjh@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Needs Help For Driver of RTL8192EE
References: <CAPjrJ8+b+oPLF6nJg=iDK--B-LdAF9Hr7DUFU6iCyrvGLUmMcA@mail.gmail.com>
In-Reply-To: <CAPjrJ8+b+oPLF6nJg=iDK--B-LdAF9Hr7DUFU6iCyrvGLUmMcA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2014 02:31 AM, Lawrence Zhu wrote:
> Hi Larry.
> Thanks for your great contribution. I'm actually waiting for the stable driver
> for Lenovo t440s' wireless driver, and I saw the message here
> <http://marc.info/?l=linux-wireless&m=139648497105184> that I should contact you
> directly for this driver. Could you please help me with it?
> Thank you very much.

I am only able to supply files to patch a standard kernel, not a complete kernel 
deb file.

To obtain these patches, download the following two files:

http://www.lwfinger.com/realtek_drivers/0001-staging-r8192ee-Add-new-driver.patch
http://www.lwfinger.com/realtek_drivers/0002-staging-r8192ee-Add-new-driver.patch

Use these two files, in turn, to patch the standard 3.14.X kernel source and 
then build the custom kernel for your computer.

My efforts are on track to be able to supply this driver as a part of a standard 
kernel version 3.16.

Larry


