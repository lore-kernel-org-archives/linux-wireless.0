Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:55041 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbZHNRZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 13:25:07 -0400
Received: by bwz22 with SMTP id 22so1265942bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 10:25:08 -0700 (PDT)
To: Chunkeey@web.de
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Deauthentications with p54usb
References: <1763718213@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 14 Aug 2009 20:17:57 +0300
In-Reply-To: <1763718213@web.de> (Chunkeey@web.de's message of "Fri\, 14 Aug 2009 00\:27\:40 +0200")
Message-ID: <8763cq1fi2.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chunkeey@web.de writes:

> "Larry Finger" <Larry.Finger@lwfinger.net> wrote:
>> 
>> I'll try to collect a dump.
>> 
> Any news regarding that dump?
> Or are you too busy reviewing b43's LP code? :)
>
> It looks like more drivers are affected. 
>  - Luis reported some deauth (reasons=7) for ath9k with a cisco ap.
>  - Kalle has the same issues with wl1271 with a ?Zyxel? AP.

Actually that was with wl1251. It was a bug in the driver, I'll send a
patch within few days.

-- 
Kalle Valo
