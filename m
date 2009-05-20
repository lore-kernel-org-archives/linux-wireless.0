Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:44707 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZETU20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 16:28:26 -0400
Message-ID: <4A1467E3.1060502@gmail.com>
Date: Wed, 20 May 2009 22:28:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Tobias Doerffel <tobias.doerffel@gmail.com>
CC: linville@tuxdriver.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, me@bobcopeland.com,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ath5k: add support for radio LED
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com> <200905202216.43996.tobias.doerffel@gmail.com>
In-Reply-To: <200905202216.43996.tobias.doerffel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/2009 10:16 PM, Tobias Doerffel wrote:
> Hi,
> 
> Am Mittwoch, 20. Mai 2009 22:08:57 schrieb Jiri Slaby:
>> From: Tobias Doerffel <tobias.doerffel@gmail.com>
>>
>> I found these patches on the web not being merged since Jan. Was
>> there any reason why they shouldn't be accepted?
> Yes - they needed further work. The approach was wrong because the GPIO does 
> not control the LED rather than some internal rfkill mechanism (which itself 
> controls the LED). I therefore reworked things to have general RFKILL support 
> in ath5k and proposed the patches. They were reviewed by Bob Copeland and I 
> addressed most of the issues so far but didn't come up with a new patch yet, 
> as there're still minor things to be worked out. If there's interest, I'll 
> prepare a new patch which represents the current state.

I think we are definitely interested. Please send an updated patch.

Thanks.
