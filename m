Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44803 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab3IKRFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 13:05:24 -0400
Received: by mail-ob0-f177.google.com with SMTP id f8so8618477obp.22
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 10:05:23 -0700 (PDT)
Message-ID: <5230A2D2.3000206@lwfinger.net> (sfid-20130911_190536_530279_85C88DF1)
Date: Wed, 11 Sep 2013 12:05:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Thiele <vincentthiele@gmail.com>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com> <522E4315.4040806@lwfinger.net> <1378764913.31180.9.camel@dcbw.foobar.com> <CAEZsi7FY8HdBcb0p1svijAdFjB0MbrYv_Zft0B_+RQTpGWCnhQ@mail.gmail.com> <1378916091.1693.21.camel@dcbw.foobar.com> <52309B75.3010408@lwfinger.net> <CAEZsi7GYj5Lf4vOxJfkU+_sHk-UqHJ605Z5yPOmMcucVanR3uQ@mail.gmail.com>
In-Reply-To: <CAEZsi7GYj5Lf4vOxJfkU+_sHk-UqHJ605Z5yPOmMcucVanR3uQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2013 11:53 AM, Vincent Thiele wrote:
> So what should i do?

Open a command-line window and enter the command

ping x.y.z.w

where the IP address of your router replaces the x, y, z, and w.

Larry


