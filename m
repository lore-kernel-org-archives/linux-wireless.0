Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:42763 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZLHHVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 02:21:07 -0500
Received: by ewy1 with SMTP id 1so2367372ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 23:21:12 -0800 (PST)
To: Jason Young <a.young.jason@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mac80211: add U-APSD client support
References: <16a81f890912031225g888490y2e8ff92557a322b7@mail.gmail.com>
	<1260096442.3461.3.camel@johannes.local>
	<87my1v3sum.fsf@purkki.valot.fi>
	<16a81f890912071225v2a1e603cy18afdd9b652903a1@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 08 Dec 2009 09:12:49 +0200
In-Reply-To: <16a81f890912071225v2a1e603cy18afdd9b652903a1@mail.gmail.com> (Jason Young's message of "Mon\, 7 Dec 2009 12\:25\:36 -0800")
Message-ID: <87638i3pn2.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Young <a.young.jason@gmail.com> writes:

> On Mon, Dec 7, 2009 at 3:51 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>
>>>> #define IEEE80211_WMM_IE_STA_SP_ALL  (0<<5)
>>>> #define IEEE80211_WMM_IE_STA_SP_2     (1<<5)  /* or (BIT(5)) */
>>>> #define IEEE80211_WMM_IE_STA_SP_4     (2<<5)  /* or (BIT(6)) */
>>>> #define IEEE80211_WMM_IE_STA_SP_6     (3<<5)  /* or (BIT(5) | BIT(6)) */
>>>
>>> Can somebody clarify for me which part of this stuff is WMM, and which
>>> is "real" 802.11 QoS?
>
> Though this patch adds support for WMM Power Save, these defines will
> work for WMM and "real" 802.11 QoS.

Yes, I agree now.

>> I took a quick peek of the 802.11-2007 QoS part. My observation was
>> that the terms are the same, but that's about it. For example QoS Info
>> field is reversed, APSD capability is advertised through beacon
>> capability bits and naturally there are proper ids for IEs.
>
> The QoS info field itself is not reversed, the figure is just reversed.

Doh, I was reading it incorrectly in "IETF mode". Thank you for
correcting me.

-- 
Kalle Valo
