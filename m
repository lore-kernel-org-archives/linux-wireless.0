Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17408 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2I1J11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 05:27:27 -0400
Message-ID: <50656D77.4040101@qca.qualcomm.com> (sfid-20120928_112731_050236_B04695F7)
Date: Fri, 28 Sep 2012 14:57:19 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Holger Schurig <holgerschurig@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<Mohammed@venema.h4ckr.net>, <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Ensure we set FTP_STOMP_LOW weight
 when WLAN is idle
References: <1348758768-5228-1-git-send-email-mohammed@qca.qualcomm.com> <CAOpc7mF8XTnW5gh7hnN=7e_M7f=wRVuPqT_7S9k2YN7tq4YXBw@mail.gmail.com>
In-Reply-To: <CAOpc7mF8XTnW5gh7hnN=7e_M7f=wRVuPqT_7S9k2YN7tq4YXBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger,


On Friday 28 September 2012 02:30 PM, Holger Schurig wrote:
>> We WLAN is idle we can some better bandwidth to FTP by
>> setting STOMP_LOW_FTP where stomping the FTP BT is pretty
>> much reduced when compared to setting STOMP_LOW weight.
>
> I understand that english isn't your first language (and neither is it
> mine). But this is quite unintelligible.

:) :)
apologies, I simply missed the commit log line, Its been sent as an RFC 
sometime and yesterday I sent the patch, apparently not much looking 
into the commit log :). Definitely its not correct and thanks for 
pointing this out.  Will send a v2!

>
> Beside wrong words (We/When) it doesn't also really say what is going
> on. What, for example, is FTP ?  How can you assume that this is
> generally known?  For sure it's not the file transfer protocol. Same
> with "FTP BT".

sure I would make it clear in the v2.

>
> Also, "we can some better bandwidth" misses a verb. "take into account
> of data packets" is weird, too.

sure, I will change in v2.

>
> Confused.
>

thanks a lot for your review and comments!


-- 
thanks,
shafi


