Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44985 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1JRPUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 11:20:44 -0400
Received: by yxp4 with SMTP id 4so689980yxp.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 08:20:44 -0700 (PDT)
Message-ID: <4E9D9953.3020601@lwfinger.net> (sfid-20111018_172055_262271_1E3C52C2)
Date: Tue, 18 Oct 2011 10:20:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: v4mp <gaigo88@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gm ail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T1  61652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org> <4E9C42CF.5010702@lwfinger.net> <loom.20111017T190430-717@post.gmane.org> <4E9CF13A.7060102@lwfinger.net> <loom.20111018T143746-420@post.gmane.org> <loom.20111018T150303-359@post.gmane.org>
In-Reply-To: <loom.20111018T150303-359@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2011 08:07 AM, v4mp wrote:
> i tested the compat wireless drivers with another alfa awus036h and it works
> well, i tested also the realtek linux drivers 8192cu and the alfa awus036nhr
> works with them in the same distro and same kernel
> with rtl8192cu and xhci_hcd there are these no room on ep ring errors :(

I'm confused about what you did.

The Alfa AWUS036H uses a completely different driver (rtl8187) than does the 
AWUS036NHR (rtl8192cu). It has been in the kernel for several years, thus using 
compat-wireless would not be necessary.

Are you saying that driver 8192cu from Realtek's web site works with your 
system, but that the kernel version from compat-wireless does not? If that is 
true, what is the exact file name of the driver you downloaded?

Larry

