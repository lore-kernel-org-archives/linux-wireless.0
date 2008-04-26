Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:24958 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbYDZRIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 13:08:17 -0400
Received: by wa-out-1112.google.com with SMTP id m16so6733582waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 26 Apr 2008 10:08:17 -0700 (PDT)
Message-ID: <1ba2fa240804261008m11c86558jad0ded68be8484b3@mail.gmail.com> (sfid-20080426_190836_597188_4DFA69B5)
Date: Sat, 26 Apr 2008 20:08:17 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: Select also LEDS_TRIGGERS.
Cc: "Priit Laes" <plaes@plaes.org>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
	reinette.chatre@intel.com
In-Reply-To: <1209226569.10943.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209033767.1368.3.camel@localhost>
	 <1ba2fa240804240424r29f4c83boa40f8172f65fd024@mail.gmail.com>
	 <1209226569.10943.49.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 26, 2008 at 7:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-04-24 at 14:24 +0300, Tomas Winkler wrote:
>  > Shouldn't be this already covered by MAC80211_LEDS
>
>  No, select isn't transitive.

Oh boy I hate when things are not intuitive... force me to read manuals ;)
Thanks
Tomas

>  johannes
>
