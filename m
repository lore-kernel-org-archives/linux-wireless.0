Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:31333 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZAGRtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 12:49:40 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] mac80211: extend/document powersave API
References: <1231264395.3654.10.camel@johannes>
	<1231273502.3767.4.camel@johannes> <878wpn5d64.fsf@nokia.com>
	<1231346625.3545.56.camel@johannes> <87tz8b3u6i.fsf@nokia.com>
	<1231349460.3545.63.camel@johannes>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 07 Jan 2009 19:49:11 +0200
In-Reply-To: <1231349460.3545.63.camel@johannes> (ext Johannes Berg's message of "Wed\, 07 Jan 2009 18\:31\:00 +0100")
Message-ID: <87priz3t2g.fsf@nokia.com> (sfid-20090107_184944_372525_FE9B2AAF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-01-07 at 19:25 +0200, Kalle Valo wrote:
>
>> > -set:
>> > + set:
>> 
>> Really? My emacs always indents it without space, should I fix my
>> settings?
>
> I like it better for two reasons:
>  (1) my editor uses a heuristic to display the function you're in, and
>      the heuristic will display the label if it's in the first column
>  (2) diff -p does the same, so you'll end up with the label in the @@
>      row which isn't very useful.
>
> The "right" way never got added to CodingStyle, despite discussions.

Ok, I'm now convinced :) I'll fix emacs to indent like this.

-- 
Kalle Valo
