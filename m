Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:47220 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668AbYLKRhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 12:37:38 -0500
Received: by wa-out-1112.google.com with SMTP id v27so486072wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 09:37:38 -0800 (PST)
Message-ID: <69e28c910812110937k1b608f25xea17b1e446c76b3b@mail.gmail.com> (sfid-20081211_183750_461295_49791DFD)
Date: Thu, 11 Dec 2008 18:37:37 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Fix for change in STA handling in mac80211
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <103016.83139.qm@web23103.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <494132C3.5070907@lwfinger.net>
	 <103016.83139.qm@web23103.mail.ird.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 6:33 PM, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
> --- On Thu, 11/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Hin-Tak Leung wrote:
>> >
>> > I don't know the verdict yet - but I think we need
>> to either revert Johannes's earlier patch, or have this
>> change from Larry incoporated, ASAP.
>> >
>> > Hin-Tak
>>
>> No, the best solution is to incorporate Johannes patch of
>> today. Now that I
>> understand what happened, my patch just wallpapers over his
>> mistake.
>>
>> To explain how that happened, he used
>> NL80211_IFTYPE_STATION (2) when he meant
>> BIT(NL80211_IFTYPE_STATION)(4). My "fix" works
>> because BIT(NL80211_IFTYPE_ADHOC)
>> == NL80211_IFTYPE_STATION.
>
> okay, I like my wlan* device not to disappear. One way or the other, this needs fixing ASAP. It was very weird to put the latest wireless-testing on and wlanX is nowhere to be found :-). I'll dig through the archive for the patch. (still not subscribe to linux-wireless - maybe I should when I figure out gmail's filtering system).
>
> Hin-Tak

A little help: Subscribe, and when you get the first message from the
list, click "Show details", then click "Filter messages from this
mailing list". Gmail will configure the filter criteria for you.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
