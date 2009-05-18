Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:38636 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbZEROmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 10:42:13 -0400
Message-ID: <4A1173D1.5010704@shockfish.com>
Date: Mon, 18 May 2009 16:42:25 +0200
From: Alexandre Becholey <alexandre@shockfish.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH]rt73usb: fix for master mode.
References: <1242651336-12621-1-git-send-email-alexandre.becholey@epfl.ch> <200905181531.37484.IvDoorn@gmail.com>
In-Reply-To: <200905181531.37484.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Monday 18 May 2009, Alexandre Becholey wrote:
>   
>> Report status unknown as if there were successfully transmitted.
>> This will avoid hostapd to disassociate because it doesn't understand what a status unknown is.
>>
>> Signed-off-by: Alexandre Becholey <alexandre.becholey@epfl.ch>
>> ---
>>  drivers/net/wireless/rt2x00/rt2x00dev.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>     
>
> Please put your patches inline, and CC me for rt2x00 related patches.
>   
Yep sorry I forgot to CC you :-/
Oups I forgot an --inline in the git-format-patch
> As for the patch it seems like you indented with spaces rather then tabs?
>   
Sorry first time I submitted a patch... I use vim and I use tabs that's 
strange.
I'll restart from the original file.

> And please put the comment inside the else statement rather then breaking
> the if-elseif-elseif list.
>
> Also have you considered the following things:
> 	RTS frames success/failure reporting?
> 	tx_success/tx_failure statistics counters (used in link_tuner as well)
>
> Thanks,
>
> Ivo
>   
Ok I'll do it, but how should I treat the status unknown for the 
statistics? as a success?

Alexandre
