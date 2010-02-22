Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60620 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0BVWpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 17:45:14 -0500
Received: by vws2 with SMTP id 2so216795vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2010 14:45:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <00ad01cab3f1$1bbf69e0$533e3da0$@com>
References: <00ad01cab3f1$1bbf69e0$533e3da0$@com>
From: Chris Martin <chris@martin.cc>
Date: Tue, 23 Feb 2010 09:44:51 +1100
Message-ID: <ad2a7a4a1002221444g50b3548cw823fa30bd36a239@mail.gmail.com>
Subject: Re: Custom Configurations
To: Abdul Hakeem <alhakeem@gmail.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 5:59 AM, Abdul Hakeem <alhakeem@gmail.com> wrote:
> Hello,
> Can anyone share some thoughts on custom configuration of an AP to allow for
> specifics such as:
>
> 64K bandwidth limit per client
> UDP connection only.
>
> Best regards,
> AH
>
> _______________________________________________
> HostAP mailing list
> HostAP@lists.shmoo.com
> http://lists.shmoo.com/mailman/listinfo/hostap
>
>

You can block TCP etc using ipTables, but for the throttling you will
need a bit extra
have a look at this project
http://frottle.sourceforge.net/

Cheers

----------------------------------------------------------
Chris Martin
m: 0419812371
----------------------------------------------------------
