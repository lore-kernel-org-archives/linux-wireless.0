Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35426 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKJUsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 15:48:47 -0500
Received: by mail-oi0-f46.google.com with SMTP id g201so5977048oib.5
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 12:48:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <545F4611.3010207@broadcom.com>
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
	<545F4611.3010207@broadcom.com>
Date: Mon, 10 Nov 2014 14:48:46 -0600
Message-ID: <CAMP44s1NiYrFkN=DQcyGiJyW+JvCGvRVzcEBGLtvGyhfWs17kQ@mail.gmail.com> (sfid-20141110_214850_581335_3012A075)
Subject: Re: brcmfmac not working on ECS LIVA
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Nov 9, 2014 at 4:46 AM, Arend van Spriel <arend@broadcom.com> wrote:

> The ideas may come to us with a bit more trace information. The logging
> above is the usual stuff so no problem indication there.
>
> I looked at the nvram file from [1]. At the end there are some entries about
> OOB wakeup, ie. starting with 'sd_'. You may remove those, but giving the
> logging it would not be the first thing to do.

I removed the sd_ lines, it didn't help.

> Could you share the nvram obtained from EFI? Also please create a kernel log
> with debug=0xd416.

Sure, the nvram file is here:

http://pastie.org/9710358

I tried adding this file:

/etc/modprobe.d/brcmfmac.conf
options brcmfmac debug=0xd416

I see nothing extra in the debug log... Am I doing something wrong?

-- 
Felipe Contreras
