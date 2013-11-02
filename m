Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35682 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3KBVxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 17:53:38 -0400
Received: by mail-ob0-f175.google.com with SMTP id wm4so5779256obc.6
        for <linux-wireless@vger.kernel.org>; Sat, 02 Nov 2013 14:53:38 -0700 (PDT)
Message-ID: <5275745F.9080002@lwfinger.net> (sfid-20131102_225345_298029_B08FF0CD)
Date: Sat, 02 Nov 2013 16:53:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alexandre.f.demers@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: r92su: status and will it be merged anytime soon?
References: <52755E44.1060501@gmail.com>
In-Reply-To: <52755E44.1060501@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2013 03:19 PM, Alexandre Demers wrote:
> Good afternoon,
>
> I was playing in r8712u because I wanted to send a patch to conditionally
> silence a flooding netdev_info(). But then I found out on
> http://wireless.kernel.org/en/users/Drivers/rtl819x that r8712u was to be
> replaced by r92su.
>
>  From its git tree, it seems no commit were added since 4 months ago. Could
> someone tell me in what shape is this new driver? Is there any plan to merge it
> (under staging I suppose) soon?

As nothing has happened with that GitHub account for several months, my guess is 
that it will not be merged any time soon.

It would make little sense to replace one staging driver (r8712u) with a 
different one. The only thing that makes sense is for it to use mac80211 and be 
merged in the regular drivers/net/wireless/rtlwifi tree.

Larry


