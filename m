Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39406 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3ILBxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 21:53:32 -0400
Received: by mail-ob0-f174.google.com with SMTP id wd6so9183698obb.5
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 18:53:32 -0700 (PDT)
Message-ID: <52311E9A.7030902@lwfinger.net> (sfid-20130912_035337_355148_0BD86701)
Date: Wed, 11 Sep 2013 20:53:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Thiele <vincentthiele@gmail.com>
CC: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com> <522E4315.4040806@lwfinger.net> <1378764913.31180.9.camel@dcbw.foobar.com> <CAEZsi7FY8HdBcb0p1svijAdFjB0MbrYv_Zft0B_+RQTpGWCnhQ@mail.gmail.com> <1378916091.1693.21.camel@dcbw.foobar.com> <52309B75.3010408@lwfinger.net> <5230A440.5050709@ilande.co.uk> <5230B573.9030800@lwfinger.net> <CAEZsi7G+FqUh2fBXLLR17qiBb1ggLu2+11aYRt2Wppr1gGK-Wg@mail.gmail.com>
In-Reply-To: <CAEZsi7G+FqUh2fBXLLR17qiBb1ggLu2+11aYRt2Wppr1gGK-Wg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vincent,

If you are still running kernel 3.8, then there is nothing I can do. I made a 
lot of changes that are included in the 3.11 kernel, and they fix a lot of 
things, but they could not be backported to 3.8.

It turns out that ping also made no difference here. Since my last reboot, my 
RTL8192CU device has been connected for 4 hours with no disconnections.

Larry

