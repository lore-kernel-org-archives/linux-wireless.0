Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49804 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759713Ab1JGJnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 05:43:14 -0400
Received: by ggnv2 with SMTP id v2so2563945ggn.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 02:43:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317977814.3988.10.camel@jlt3.sipsolutions.net>
References: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com>
	<1317977814.3988.10.camel@jlt3.sipsolutions.net>
Date: Fri, 7 Oct 2011 11:43:14 +0200
Message-ID: <CAGXE3d97E-itEf5VE7RVt01fRmq-EtERyCnUYrrvx6r=io+Mqg@mail.gmail.com> (sfid-20111007_114318_351945_BC7875E5)
Subject: Re: [PATCH] mac80211: Allow NO_ACK flag overwrite for injected frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2011 at 10:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-29 at 11:27 +0200, Helmut Schaa wrote:
>
>> +             case IEEE80211_RADIOTAP_TX_FLAGS:
>> +                     txflags = le16_to_cpu(get_unaligned((__le16*)
>> +                                             iterator.this_arg));
>> +                     if (txflags & IEEE80211_RADIOTAP_F_TX_NOACK)
>> +                             info->flags |= IEEE80211_TX_CTL_NO_ACK;
>> +                     break;
>> +
>>               /*
>>                * Please update the file
>>                * Documentation/networking/mac80211-injection.txt
>
> ... :-)

Oops. I'll send a followup ...
