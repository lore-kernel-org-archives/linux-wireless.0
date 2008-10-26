Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:7985 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYJZUeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 16:34:44 -0400
Received: by rn-out-0910.google.com with SMTP id k40so931911rnd.17
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 13:34:42 -0700 (PDT)
Message-ID: <445f43ac0810261334y7c064785gbf83efe3ab00cdf9@mail.gmail.com> (sfid-20081026_213449_829560_0C234150)
Date: Sun, 26 Oct 2008 13:34:41 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point operation
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1225008571.3478.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
	 <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
	 <200810251228.17562.IvDoorn@gmail.com>
	 <445f43ac0810251820p71e6e330tba6ba9475ca8aa48@mail.gmail.com>
	 <1225008571.3478.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes, Ivo,

On Sun, Oct 26, 2008 at 1:09 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2008-10-25 at 18:20 -0700, Javier Cardona wrote:
>> Ivo,
>>
>> On Sat, Oct 25, 2008 at 3:28 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>> > For rt2x00 this would turn into:
>> >        FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS
>>
>> With the above configuration, will the rt2x00 device acknowledge 1)
>> unicast frames addressed to itself? 2) unicast frames addressed to
>> others? 3) none of the above?
>
> It should always only be (1), mac80211 might set OTHER_BSS if it (well,
> the user) wants to see traffic on the same channel from other BSSes.

Good.  My concern was that FIF_PROMISC_IN_BSS would disable all
acknowledgments.  (I've seen some wireless hw with that behavior)

Thanks!


-- 
Javier Cardona
cozybit Inc.
