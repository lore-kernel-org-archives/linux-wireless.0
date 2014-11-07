Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58429 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751806AbaKGThi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:37:38 -0500
In-Reply-To: <1415387721.1954.0.camel@sipsolutions.net>
References: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net> <1415363870.12617.0.camel@coelho.fi> <1415387721.1954.0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
From: Luca Coelho <luca@coelho.fi>
Date: Fri, 07 Nov 2014 21:37:25 +0200
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Message-ID: <1D96301C-ADA3-4A41-9E1D-97D5A5C82B94@coelho.fi> (sfid-20141107_203741_742974_3386DCC6)
Subject: Re: [PATCH] mac80211: add back support for radiotap vendor namespace data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On November 7, 2014 9:15:21 PM EET, Johannes Berg <johannes@sipsolutions.net> wrote:
>On Fri, 2014-11-07 at 14:37 +0200, Luca Coelho wrote:
>
>> > +#if 0
>> > +	struct ieee80211_vendor_radiotap *rtap;
>> > +
>> > +	rtap = (void *)skb_push(skb, sizeof(*rtap) + 8 + 4);
>> > +	/*
>> > +	 * Don't enable this code by default as the OUI 00:00:00
>> > +	 * is registered to Xerox so we shouldn't use it here, it
>> > +	 * might find its way into pcap files.
>> > +	 * Note that this code requires the headroom in the SKB
>> > +	 * that was allocated earlier.
>> > +	 */
>
>> Is this #if 0'ed section here on purpose? If yes, maybe explain it in
>> the commit message?
>
>You're the second person to ask this, but come on ... really? :)

Okay, I know I'm missing something. But i just hate #if 0s, especially when I don't easily understand the need for them.


>
>johannes


