Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37467 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0AEKPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 05:15:36 -0500
Received: by bwz27 with SMTP id 27so9796359bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 02:15:34 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/9] mac80211: create Probe Request template
References: <20100103210552.29287.20384.stgit@tikku>
	<20100103210749.29287.96141.stgit@tikku>
	<1262683265.20098.7.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 12:15:32 +0200
In-Reply-To: <1262683265.20098.7.camel@johannes.local> (Johannes Berg's message of "Tue\, 05 Jan 2010 10\:21\:05 +0100")
Message-ID: <874on0x3gb.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sun, 2010-01-03 at 23:07 +0200, Kalle Valo wrote:
>
>> + * @ie: buffer containing all IEs expect SSID for the template
>
> typo -> except

Fixed.

>> + * @ie_len: length of the IE buffer
>> + *
>> + * Creates a Probe Request template which can, for example, uploaded
>> to
>
> be uploaded

Fixed.

> However, there already is ieee80211_send_probe_req and
> ieee80211_build_preq_ies -- shouldn't this use some of the new code?

Yes, patch 5 does this.

-- 
Kalle Valo
