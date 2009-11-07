Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:47124 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZKGSKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 13:10:01 -0500
Received: by ewy3 with SMTP id 3so1999164ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2009 10:10:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1250927141.23605.3.camel@johannes.local>
References: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
	 <1250927141.23605.3.camel@johannes.local>
Date: Sat, 7 Nov 2009 19:10:05 +0100
Message-ID: <83a869cd0911071010g32c798c6pfecd875a1bf484e0@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

sorry for the long delay.

On Sat, Aug 22, 2009 at 8:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-08-22 at 00:13 +0200, gregor kowski wrote:
>
>> +enum ieee80211_internal_tkip_initialized {
>> +     TKIP_INITIALIZED_NONE,
>> +     TKIP_INITIALIZED_PHASE1,
>> +     TKIP_INITIALIZED_UPDATE_KEY,
>> +};
>
> Those constants and the enum itself really need better names. This way,
> there's no way to understand what it means without reading all the code.
>
Could you suggest better name ?

ieee80211_internal_tkip_state and
TKIP_STATE_NOT_INIT
TKIP_STATE_PHASE1_DONE
TKIP_STATE_PHASE1_HW_UPLOADED
?

Thanks

Gregor
