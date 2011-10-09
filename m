Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54801 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1JIOrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Oct 2011 10:47:31 -0400
Received: by ggnv2 with SMTP id v2so3859678ggn.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Oct 2011 07:47:31 -0700 (PDT)
Message-ID: <4E91B400.1020305@lwfinger.net> (sfid-20111009_164740_156477_2BF9C6E6)
Date: Sun, 09 Oct 2011 09:47:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: v4mp <gaigo88@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9xOn5hutA6q01r0yBeOXz0ivw@mail.gmail.com> <loom.20111009T161348-133@post.gmane.org>
In-Reply-To: <loom.20111009T161348-133@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/2011 09:21 AM, v4mp wrote:
>
> Sorry, but i can't get this Alfa product to work with the latest bleeding edge
> compat-wireless-2011-10-08 on ubuntu 11.04, tryed with kernels 2.6.38-11,
> 2.6.39 rc4 and 3.0
>
> i tryed also the 2.6.39-1 version of compat-wireless
>
> Don't show anything in managed and monitor mode..

I do not know about monitor mode, but the Alfa device works in managed mode with 
kernel 3.1-rc9 from both wireless-testing and mainline. I use NetworkManager. 
All of this current code should be in the latest bleeding edge compat-wireless 
version.

Have you installed the firmware?

Larry

