Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46154 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab0I3Rda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 13:33:30 -0400
Received: by gye5 with SMTP id 5so785990gye.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 10:33:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9D3ED2EB2589B641B6CCA9F529CAA6A2FC5433@exbe12.nasstar-t1.net>
References: <9D3ED2EB2589B641B6CCA9F529CAA6A2F258CB@exbe12.nasstar-t1.net>
 <AANLkTi=aBPTYZB62Jup4=10_D2wxEgVaBormJcZb6qyT@mail.gmail.com> <9D3ED2EB2589B641B6CCA9F529CAA6A2FC5433@exbe12.nasstar-t1.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 30 Sep 2010 10:33:09 -0700
Message-ID: <AANLkTinAnawV3JThYNdovcBY4HaUOH-Sydwi1JKKoz+W@mail.gmail.com>
Subject: Re: [ath9k-devel] Modulation schemes on ath9k
To: Mike Pithouse <mike.pithouse@vegastream.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 10:26 AM, Mike Pithouse
<mike.pithouse@vegastream.com> wrote:
> Just the ticket - thank you.
>
> I see there's currently some 'inactive' code that will allow the same command to be used to set the MCS index.
>
> Do you know when/if this code will be available?  Alternatively, is there another method currently available to set MCS index?

Johannes, is this a TODO still?

  Luis

> Thanks, Mike.
>
>
>
> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com]
> Sent: 24 September 2010 16:45
> To: Mike Pithouse
> Cc: ath9k-devel@venema.h4ckr.net
> Subject: Re: [ath9k-devel] Modulation schemes on ath9k
>
> On Fri, Sep 24, 2010 at 7:53 AM, Mike Pithouse
> <mike.pithouse@vegastream.com> wrote:
>> Hi all,
>>
>>
>>
>> Is is possible to set an ath9k-based access point’s Modulation scheme using
>> iw or similar?
>
> iw dev <devname> set bitrates [legacy-<2.4|5> <legacy rate in Mbps>*]
>
>  Luis
>
