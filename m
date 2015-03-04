Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33881 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbbCDSak (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 13:30:40 -0500
Message-ID: <1425493829.1810.13.camel@sipsolutions.net> (sfid-20150304_193044_417795_93E9CAB7)
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for
 tdls station
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Wed, 04 Mar 2015 19:30:29 +0100
In-Reply-To: <CA+XVXfeG0TZ+jdRKhcZHzUjxffFbmzJBPtW2nrQ0+JjKC_+mbQ@mail.gmail.com> (sfid-20150304_173107_010073_3C2EA458)
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
	 <CADnKcVjWiHi1RsYwiE6buMduq19i3A5qt8w93VLz6dRg-qLOLQ@mail.gmail.com>
	 <CA+XVXfeG0TZ+jdRKhcZHzUjxffFbmzJBPtW2nrQ0+JjKC_+mbQ@mail.gmail.com>
	 (sfid-20150304_173107_010073_3C2EA458)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-04 at 18:30 +0200, Arik Nemtsov wrote:
> On Wed, Mar 4, 2015 at 12:38 PM, Marek Puzyniak
> <marek.puzyniak@tieto.com> wrote:
> > On 4 March 2015 at 11:04, Arik Nemtsov <arik@wizery.com> wrote:
> >> I can do it, but I'll probably only get to it next week.
> >
> > I will try to prepare patch this week, if not I will wait for Arik's
> > proposition.
> >
> > For ath10k rate control need to be initialised before moving to
> > STA_AUTHORIZED, so initialising rate control before STA_ASSOC is
> > perfectly fine.
> 
> Ok I did get to it today :)
> With the attached patch applied, and the patch "mac80211: update TDLS
> sta spatial streams before auth" reverted, I'm getting good
> performance on iwlwifi.

Cool. I think I'll apply this, but with the comment fixed to say
"associated" :)

But perhaps you can send this as a real patch to the list?

johannes

