Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46316 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaDYJt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 05:49:58 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so3443760wgh.32
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 02:49:57 -0700 (PDT)
Message-ID: <535A2FC2.4080508@gmail.com> (sfid-20140425_115007_199057_9058A5AC)
Date: Fri, 25 Apr 2014 12:49:54 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Pierre Bourdon <delroth@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Ryan Houdek <sonicadvance1@gmail.com>, tilkax@gmail.com
Subject: Re: Odd network behaviors with an Intel Wireless 7260
References: <CA+V6dmjwfsrDSDQWHHCFbW9L14GnzifoSjH5UOS4zTSusRtYow@mail.gmail.com> <535A13FA.4070405@gmail.com> <CA+V6dmjcYxTjYyjk7kd2-=ijXyqvWL=8bV1YQ0ejeSAK62qapw@mail.gmail.com>
In-Reply-To: <CA+V6dmjcYxTjYyjk7kd2-=ijXyqvWL=8bV1YQ0ejeSAK62qapw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/25/2014 11:08 AM, Pierre Bourdon wrote:
> [+ another user who reported similar issues]
> 
> On Fri, Apr 25, 2014 at 9:51 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> Thank you very much for this very detailed report.
>> 1) can you try with power save disabled?
>>    sudo iw wlan0 set power_save off
> 
> Thanks for the suggestion. I will be testing this over the week-end.
> Since this is a random issue (happens every few hours) I will not be
> able to be fully certain how much it helps, but I will definitely
> notice large improvements / complete mitigations.
> 
> FWIW, I've had this issue happen with several 7260 fw versions. Was
> uAPSD always advertised as supported or is it an addition of newer
> firmwares?
> 

Hmm... What kernel are you using?
IIRC 22.1.7.0 doesn't have uAPSD support - so if it the problem exists with this firmware, then we should look for something else.
