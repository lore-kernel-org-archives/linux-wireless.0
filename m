Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58882 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab2EaCiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 22:38:17 -0400
Received: by lbbgm6 with SMTP id gm6so499385lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 19:38:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj987H6wrN5ayRqh1QiE_OKbi_9bj1OCeFCrht0yKtkz0mqA@mail.gmail.com>
References: <1338430181-12490-1-git-send-email-yeohchunyeow@gmail.com>
 <CAGRGNgWXF5AMQfSkoCBGWgB1sod6fOEqViDiFCif2hqLx55N0g@mail.gmail.com> <CAEFj987H6wrN5ayRqh1QiE_OKbi_9bj1OCeFCrht0yKtkz0mqA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 31 May 2012 12:37:55 +1000
Message-ID: <CAGRGNgWe26p2z4amWBPv8qraKhi-W8YaGunf7g=5ySAN4w9E6Q@mail.gmail.com> (sfid-20120531_043821_330847_A65E7E82)
Subject: Re: [PATCH] {nl,cfg,mac}80211: implement dot11MeshHWMPconfirmationInterval
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chun-Yeow,

On Thu, May 31, 2012 at 12:31 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Julian
>
>> This doesn't make sense.
>>
>> Is this what you're trying to say?
>>
>> "Minimum interval of time (in TUs) between sending Action frames
>> containing PREQ elements for root path confirmation."
>
> Hi, Julian
>
> I have captured this directly from the standard. It actually means
> that once the mesh STA receives the RANN, it can send the PREQ to the
> root mesh STA if the the last PREQ to the root mesh STA was sent
> dot11MeshHWMPconfirmationInterval TUs (or more) ago.

Ok, my re-phrasing of it was right, it's just that the sentence in the
standard is wording it really clumsily.

But if that's what it says in the standard, then that's what should be
said here.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
