Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f186.google.com ([209.85.222.186]:51506 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0CXGzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 02:55:12 -0400
Received: by pzk16 with SMTP id 16so3505202pzk.22
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 23:55:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269411280.10120.806.camel@wimaxnb.nmp.nokia.com>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
	<1269327754-995-2-git-send-email-juuso.oikarinen@nokia.com>
	<43e72e891003230923r60522440vff7c1db26300ca91@mail.gmail.com>
	<1269411280.10120.806.camel@wimaxnb.nmp.nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Mar 2010 23:54:52 -0700
Message-ID: <43e72e891003232354l6e464a90ua1f02bb8bb13b19@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: Add connection quality monitoring support
	to nl80211
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 11:14 PM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> On Tue, 2010-03-23 at 17:23 +0100, ext Luis R. Rodriguez wrote:
>> On Tue, Mar 23, 2010 at 12:02 AM, Juuso Oikarinen
>> <juuso.oikarinen@nokia.com> wrote:
>>
>> > + * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm
>>
>> I still don't get what this particular value is for, despite this kdoc entry.
>>
>>   Luis
>
> I will submit one more patch to elaborate this doc further.
>
> In the meanwhile, to explain it here, this value defines the minimum
> value the RSSI level must change before the RSSI event can be issued
> again, to limit the effect of a RSSI value that is oscillating around
> the configured threshold.

Thanks Jusso, that makes it crystal clear.

  Luis
