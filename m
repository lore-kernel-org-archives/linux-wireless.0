Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:47443 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZI3VRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 17:17:33 -0400
Received: by ey-out-2122.google.com with SMTP id 4so572712eyf.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 14:17:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253965154.5122.7.camel@johannes.local>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
	 <1253859759.3868.569.camel@johannes.local>
	 <3ace41890909250854t3062d1betf89501e5775ccdd0@mail.gmail.com>
	 <1253965154.5122.7.camel@johannes.local>
Date: Wed, 30 Sep 2009 22:17:36 +0100
Message-ID: <3ace41890909301417j5966336dn197a45cf66c2cd1e@mail.gmail.com>
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 26, 2009 at 12:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:

> The extra deauth is because cfg80211 already starts the auth with the
> BSS before wpa_supplicant set the BSSID, and then when setting the BSSID
> it asks for deauth, but before we ever actually did anything... I think
> we'll just have to live with that, since it's hard to fix in the layered
> design we have now.

Hmm, I looked at the AP log, and the deauth is there... also I think
due to recent changes, association takes longer now. Is there
something that can be done in userland, for example?

Hin-Tak
