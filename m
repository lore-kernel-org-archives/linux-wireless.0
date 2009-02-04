Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:56680 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZBDTn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 14:43:28 -0500
Received: by ewy14 with SMTP id 14so3792136ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 11:43:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a4c529250902041132t6e9bcb79jfd412320fc088ff4@mail.gmail.com>
References: <a4c529250902040227g35a375fdu35c2360f0916dba6@mail.gmail.com>
	 <a4c529250902040243r6146f56vb2c656818385c749@mail.gmail.com>
	 <3ace41890902040717l7174fc0xc4589f17ea283e9c@mail.gmail.com>
	 <a4c529250902041132t6e9bcb79jfd412320fc088ff4@mail.gmail.com>
Date: Wed, 4 Feb 2009 19:43:26 +0000
Message-ID: <3ace41890902041143w49ab91baoc7b461b5629a0cc@mail.gmail.com> (sfid-20090204_204333_116994_D9F655AA)
Subject: Re: zd1211rw NEW RF Type
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Ismael Ojeda Perez <iojedaperez@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 4, 2009 at 7:32 PM, Ismael Ojeda Perez
<iojedaperez@gmail.com> wrote:

> Thanks for your kind help as you say it was as easy as modifying the
> line and the device is now working perfectly.
> i added just below line 89 the following code
> case MAXIM_NEW_RF:
>                r = zd_rf_init_uw2453(rf);
>                break;
> Thanks ;) to you all and to the open comunity.
>

Great, there are 3 people/successes... I'll dig up the other two
e-mail addresses and write a proper patch and adding some
signed-offs....
