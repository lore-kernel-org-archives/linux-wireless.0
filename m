Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3LDIUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 03:20:44 -0500
Message-ID: <1386145241.4284.5.camel@jlt4.sipsolutions.net> (sfid-20131204_092047_816870_A65ABADD)
Subject: Re: [PATCHv3] cfg80211: add support for frequency interference event
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Rajesh Chauhan <rajeshc@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	Jeff Johnson <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>, sameert@qca.qualcomm.com,
	c_arifh@qca.qualcomm.com
Date: Wed, 04 Dec 2013 09:20:41 +0100
In-Reply-To: <1386145204.4284.4.camel@jlt4.sipsolutions.net> (sfid-20131204_092013_820427_3AA619B7)
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com>
	 <1386077130.4393.21.camel@jlt4.sipsolutions.net>
	 <CAB=NE6Xa-bdLQm8uAg9wCE0fdp4KPBZ46d5FHVHp6wCvN5=dUA@mail.gmail.com>
	 (sfid-20131203_173549_913735_1E946CDE) <1386145204.4284.4.camel@jlt4.sipsolutions.net>
	 (sfid-20131204_092013_820427_3AA619B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-04 at 09:20 +0100, Johannes Berg wrote:
> On Tue, 2013-12-03 at 17:35 +0100, Luis R. Rodriguez wrote:
> > On Tue, Dec 3, 2013 at 2:25 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >> + * @interference_source: enum nl80211_freq_interference_source_type
> > >> + *   is used to specify source of interference.
> > >
> > > Do we expect that different sources would be treated differently? If
> > > not, what use is this?
> > 
> > That was because of my nagging, without such a field the type of
> > interference would be completely ambiguous and we'd have no users on
> > the Linux kernel of this API,
> 
> Wait, we have no users for this API? Forget it then - I thought you were
> going to post a patch soon. I guess I should have learned by now not to
> trust QCA with this.
> 
> I'll drop this until I see a patch using it.

You can see this as a carrot (or stick, depending on how you look at it)
for upstreaming the driver that wants it.

johannes

