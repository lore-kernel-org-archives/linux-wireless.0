Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46124 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab2GLDZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 23:25:03 -0400
Received: by gglu4 with SMTP id u4so1984091ggl.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 20:25:03 -0700 (PDT)
Message-ID: <4FFE437E.8080008@lwfinger.net> (sfid-20120712_052509_361087_1C5CA681)
Date: Wed, 11 Jul 2012 22:24:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ouyang <ilhebe999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: problem with installing the kernel
References: <loom.20120712T044726-224@post.gmane.org>
In-Reply-To: <loom.20120712T044726-224@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2012 09:52 PM, Ouyang wrote:
> I add something to the wireless-testing and then run:
>> make modules
>> make bzImage
>
> it seems all fine. but could not go any further
> # make modules_install
> rm:invalid option -- '3'
> Try 'rm -- help' for more information
> make : *** [_modinst_] Error 1
>
> Could anyone please help me with the situation?
>   The version of the linux is 3.4.4-3.fc17.x86_64 #1

Are you building the kernel as root? That is a terrible policy!!!

You should run "make" as a regular user, and follow that with "sudo make 
modules_install install". If that fails, you need to ask about the problem at 
Fedora. The standard kernel does the modules installation without any problems.

Larry

