Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:40422 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbbK0Ioi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:44:38 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?utf-8?Q?Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>
Subject: Re: [PATCH v2 7/8] cfg80211: Add Kconfig option for ITS-G5 band (5.9 GHz)
In-Reply-To: <1448612707.2531.1.camel@sipsolutions.net>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz> <1448303241-27747-8-git-send-email-sojkam1@fel.cvut.cz> <1448560529.2167.43.camel@sipsolutions.net> <87d1uw31r1.fsf@steelpick.2x.cz> <1448612707.2531.1.camel@sipsolutions.net>
Date: Fri, 27 Nov 2015 09:44:35 +0100
Message-ID: <8737vr3k7g.fsf@steelpick.2x.cz> (sfid-20151127_094441_864073_880305D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 27 2015, Johannes Berg wrote:
> On Thu, 2015-11-26 at 22:10 +0100, Michal Sojka wrote:
>> 
>> Because in [1] Jouni said that
>> 
>>    "kernel config option + custom regdb would certainly be much
>> closer to what I'd like to see from the regulatory enforcement view
>> point"
>> 
>> I also like the fact that the help text mentions the relevant
>> regulatory documents. I guess the users would appreciate that.
>> 
>
> Fair enough, but I'm not really convinced that the Kconfig option is
> needed for what Jouni really required.
>
> In any case, I spoke with him yesterday and we don't think that your
> patches are going to work as is - we'll need to change the regulatory
> flags it seems. I'll comment more specifically on the patches.

OK. I'll wait for that.

-Michal
