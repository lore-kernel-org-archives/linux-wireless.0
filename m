Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:55387 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3BZOJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 09:09:56 -0500
Received: by mail-oa0-f42.google.com with SMTP id i18so5271123oag.29
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2013 06:09:55 -0800 (PST)
Message-ID: <512CC231.6000205@lwfinger.net> (sfid-20130226_151005_279626_C66B5263)
Date: Tue, 26 Feb 2013 08:09:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "yvan.labadie@soledge.fr" <yvan.labadie@soledge.fr>
CC: Yvan <yvan.labadie@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath6kl: AR6004 failed to start on computer boot
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com> <87ehghanxe.fsf@kamboji.qca.qualcomm.com> <CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com> <511E44B8.3000308@qca.qualcomm.com> <CADGp=QfOyyTpwEg1=XXiyvRE7ZOGsn6TfiPQHs3+Jc3C69RM6Q@mail.gmail.com> <51265413.9080609@lwfinger.net> <87mwuwqtgh.fsf@kamboji.qca.qualcomm.com> <loom.20130225T175854-850@post.gmane.org> <512BBE05.9010006@lwfinger.net> <1448005898.305768.1361866657564.open-xchange@ox-webdesk.1and1.fr>
In-Reply-To: <1448005898.305768.1361866657564.open-xchange@ox-webdesk.1and1.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2013 02:17 AM, yvan.labadie@soledge.fr wrote:
> Thank's for the quick answer!
> I don't use modprobe, I use insmod/rmmod.
> Loading/unloading the module doesn't change anything.
> I tried multiple combination of physicaly connecting/disconnecting the dongle
> and loading/unloading the modules, never got it working.

As modprobe uses insmod/rmmod for its heavy lifting, you are doing essentially 
the same thing. It seems that the chip has some other problem. As I know nothing 
about it, I cannot help.

Larry


