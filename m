Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:41799 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbbCDKES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 05:04:18 -0500
Received: by lbvp9 with SMTP id p9so20114093lbv.8
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2015 02:04:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425456998.1810.3.camel@sipsolutions.net>
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
 <1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com>
 <1425041427.1960.1.camel@sipsolutions.net> <CA+XVXfchZ+L1iH47S=rM04vJbjBSKA4O8TYuhEkfZuLpNb9QDA@mail.gmail.com>
 <1425374299.2450.18.camel@sipsolutions.net> <CA+XVXffHENxD3z9dTn_LC9c7Ot0Q4FgyEoHLjdeiDTFWQGuF9w@mail.gmail.com>
 <1425377192.2450.34.camel@sipsolutions.net> <CA+XVXfdu2fCLXBP1VkMOX9nnoqCiH+h=pwzGAQ2KkBrf-H9MCQ@mail.gmail.com>
 <1425456998.1810.3.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 4 Mar 2015 12:04:01 +0200
Message-ID: <CA+XVXfdnTATvbPSkHmGSyMF5d++OmYySskD7D50YvH-wf4eM=w@mail.gmail.com> (sfid-20150304_110425_437512_F44162D6)
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for tdls station
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 4, 2015 at 10:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2015-03-03 at 12:07 +0200, Arik Nemtsov wrote:
>
>> > And doing so would also address the nss problem, right? IIRC that's done
>> > in the rate control init inline.
>>
>> Right.
>
> Can one of you (Marek/Arik) send a combined patch then please? :)

I can do it, but I'll probably only get to it next week.

Arik
