Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33587 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105AbbCDKi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 05:38:58 -0500
Received: by iecar1 with SMTP id ar1so66082321iec.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2015 02:38:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfdnTATvbPSkHmGSyMF5d++OmYySskD7D50YvH-wf4eM=w@mail.gmail.com>
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
	<1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com>
	<1425041427.1960.1.camel@sipsolutions.net>
	<CA+XVXfchZ+L1iH47S=rM04vJbjBSKA4O8TYuhEkfZuLpNb9QDA@mail.gmail.com>
	<1425374299.2450.18.camel@sipsolutions.net>
	<CA+XVXffHENxD3z9dTn_LC9c7Ot0Q4FgyEoHLjdeiDTFWQGuF9w@mail.gmail.com>
	<1425377192.2450.34.camel@sipsolutions.net>
	<CA+XVXfdu2fCLXBP1VkMOX9nnoqCiH+h=pwzGAQ2KkBrf-H9MCQ@mail.gmail.com>
	<1425456998.1810.3.camel@sipsolutions.net>
	<CA+XVXfdnTATvbPSkHmGSyMF5d++OmYySskD7D50YvH-wf4eM=w@mail.gmail.com>
Date: Wed, 4 Mar 2015 11:38:57 +0100
Message-ID: <CADnKcVjWiHi1RsYwiE6buMduq19i3A5qt8w93VLz6dRg-qLOLQ@mail.gmail.com> (sfid-20150304_113908_306161_531E99BD)
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for tdls station
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 March 2015 at 11:04, Arik Nemtsov <arik@wizery.com> wrote:
> I can do it, but I'll probably only get to it next week.

I will try to prepare patch this week, if not I will wait for Arik's
proposition.

For ath10k rate control need to be initialised before moving to
STA_AUTHORIZED, so initialising rate control before STA_ASSOC is
perfectly fine.

Marek
