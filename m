Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:45686 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067AbZJGCJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 22:09:38 -0400
Message-ID: <4ACBF821.8030508@cmu.edu>
Date: Tue, 06 Oct 2009 22:08:33 -0400
From: Aditya Bhave <aybhave@cmu.edu>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] Regarding changing channel widthlin
References: <43e72e890910061721o5f78f82cvfaa216a4d887e4f8@mail.gmail.com>
In-Reply-To: <43e72e890910061721o5f78f82cvfaa216a4d887e4f8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there any detailed documentation on the internals of ath5k code?

1. Description of the data structures
2. Flow-diagram of function calls
3. What register is used for what aspect of WiFi etc etc

Thanks
--Aditya



Luis R. Rodriguez wrote:
> On Tue, Oct 6, 2009 at 5:17 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>   
>> Until we have a
>> clean way to set this through cfg80211/nl80211 (which is an ongoing
>> discussion) we wont support 5/10Mhz operation but you can try and let
>> us know.
>>     
>
> I believe the cfg80211/nl80211 changes is probably the bulk of the
> work that does need to get done. Someone motivated just needs to do
> it.
>
>    Luis
>
>   

