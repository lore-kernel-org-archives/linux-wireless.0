Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f212.google.com ([209.85.220.212]:55129 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbZFRRtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 13:49:55 -0400
Received: by fxm8 with SMTP id 8so1249550fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 10:49:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910906181038w7cc662a6u2d4f0f321a7b1c43@mail.gmail.com>
References: <1245340443-13214-1-git-send-email-pterjan@mandriva.com>
	 <69e28c910906181036j36fb7ad9lb9997c0920756c69@mail.gmail.com>
	 <69e28c910906181038w7cc662a6u2d4f0f321a7b1c43@mail.gmail.com>
Date: Thu, 18 Jun 2009 18:49:56 +0100
Message-ID: <3ace41890906181049l49dd1c88i251e4e6396412b8f@mail.gmail.com>
Subject: Re: [PATCH] 07b8:6001 is a ZD1211B
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Pascal Terjan <pterjan@mandriva.com>,
	Daniel Drake <dsd@gentoo.org>, kune@deine-taler.de,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/18 Gábor Stefanik <netrolller.3d@gmail.com>:
> Forgot to CC the list, sorry. (What happened to "Default Reply to All"?)
>
> 2009/6/18 Gábor Stefanik <netrolller.3d@gmail.com>:
>> This appears to be the same as
>> http://osdir.com/ml/network.wireless.zd1211.devel/2007-07/msg00038.html
>>
>> However, I can't actually find any trace of non-B ZD1211s with this ID.

Argh -- I think it is probably a good idea to stick a comment next to
that id saying it might be in the other section. (i.e. put this next
to the code). This is an instance where some punishment of the
manufacturer is deemed appropriate :-).

FWIW, Epson uses the same product id for both their stylus inkjets and
their cheap EPL laser printer series :-). Luckily, it is usually quite
obvious which one is which from just looking at the device... if the
user can be confused by that, he/she should not be allowed near a
printer...
