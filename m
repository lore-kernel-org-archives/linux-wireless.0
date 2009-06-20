Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:53059 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZFTApm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 20:45:42 -0400
Received: by gxk10 with SMTP id 10so3449445gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 17:45:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A3BC8EC.6040801@gmail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
	<1245363695-8289-3-git-send-email-kilroyd@googlemail.com>
	<646765f40906181638j39d8e8eex8ead9d856b5f2548@mail.gmail.com>
	<4A3BC8EC.6040801@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 20 Jun 2009 10:38:03 +1000
Message-ID: <646765f40906191738l74cfc45dn25618f402cd21a3d@mail.gmail.com>
Subject: Re: [PATCH 02/23] cfg80211: Advertise ciphers via WE according to
	driver capability
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 20, 2009 at 03:20, Dave<kilroyd@googlemail.com> wrote:
> Julian Calaby wrote:
>> On Fri, Jun 19, 2009 at 08:21, David Kilroy<kilroyd@googlemail.com> wrote:
>>> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
>>> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>>> ---
>>>  net/wireless/wext-compat.c |   15 +++++++++++++--
>>>  1 files changed, 13 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
>>> index 9e56f35..7dbe6c6 100644
>>> --- a/net/wireless/wext-compat.c
>>> +++ b/net/wireless/wext-compat.c
>>> @@ -204,8 +204,19 @@ int cfg80211_wext_giwrange(struct net_device *dev,
>>>        range->avg_qual.noise = range->max_qual.noise / 2;
>>>        range->avg_qual.updated = range->max_qual.updated;
>>>
>>> -       range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
>>> -                         IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
>>> +       range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2;
>>
>> Should this should go into the for loop too, like how patch 5 works?
>
> Err... patch 5 moves this line into the for loop. I moved these in
> separate patches because:

You know, it does. Argh! This is what you get for not reading the
patches properly.

> As it happens, no-one has objected (yet).

Hmm, yes.

> Apologies if I've completely misunderstood you.

No, you haven't.

Sorry for the noise.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
