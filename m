Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:46503 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZCIFx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 01:53:29 -0400
Received: by rv-out-0506.google.com with SMTP id g9so1585443rvb.5
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2009 22:53:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9360e520903082249w43a2c670oad8f5c56ca0df638@mail.gmail.com>
References: <d9360e520903082249w43a2c670oad8f5c56ca0df638@mail.gmail.com>
Date: Mon, 9 Mar 2009 11:23:27 +0530
Message-ID: <d9360e520903082253p495326caj543442e1f26862a4@mail.gmail.com> (sfid-20090309_065333_700019_B6F15C02)
Subject: Re: crash in wlan stack due to my code
From: Bharat Bhushan <bharat.b.bhushan@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

typo the crahing function name is sysfs_create_link not sysfs_create_fs
thanks
bharat

On Mon, Mar 9, 2009 at 11:19 AM, Bharat Bhushan
<bharat.b.bhushan@gmail.com> wrote:
> Hi All,
>
> =A0 i am trying to develop open source mac driver fo our wlan device
> and Due to some inherent issues with my embedded platform i need to
> stick to the kernel veriosn 2.6.22(i guess the version when the open
> source mac was released in mainline kernel tree). i am facing a crash
> with sysfs_create_fs where BUG_ON(!kobj || !kobj->dentry || !name);
> statement is getting hit and system is crashing. Can anyone point out
> where should i initialize kobject file system in context of open
> source mac.
>
> Any help is much appreciated.
>
> Thanks
>
> bharat
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
