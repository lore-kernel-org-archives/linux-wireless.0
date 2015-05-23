Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33945 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbbEWSJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2015 14:09:32 -0400
Received: by laat2 with SMTP id t2so30192631laa.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 May 2015 11:09:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5560BD69.10409@lwfinger.net>
References: <1432014444-29039-1-git-send-email-haggai.eran@gmail.com>
	<CAJ=9Czay5pbi6p+n8SxXaJsWG4JR2p_vteKYbLxvoxLVtPQPaQ@mail.gmail.com>
	<555CB8C1.1040007@lwfinger.net>
	<CAJ=9CzYr2rFxZprM0Ap+x+Vu3LDXJUtxqtHqH-YER-ABscRb0w@mail.gmail.com>
	<CAJ=9CzbohiYSj1J4M17iK4Rqh0bopEF8zhN=Sqrh7GO6eBP-=w@mail.gmail.com>
	<5560BD69.10409@lwfinger.net>
Date: Sat, 23 May 2015 21:09:31 +0300
Message-ID: <CAJ=9CzaBfD7to1XPH6s69EuMuwpuZXSNRDoCEZpBkjzin5PgOw@mail.gmail.com> (sfid-20150523_200935_920400_A6973803)
Subject: Re: [PATCH] staging: rtl8712: prevent buffer overrun in recvbuf2recvframe
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2015 at 20:48, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> That is good news. Perhaps the debugging kernel is overflowing the stack.
> Did your debugging kernel have "Check for stack overflows" set in the
> "Memory Debugging" section of the configuration? I did not have that turned
> on until today, but it seems like a good idea.
No, I don't think they have it implemented for ARM.

> Do you want to prepare the final version of the patch, or should I?

I can send an updated patch.

Thanks,
Haggai
