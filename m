Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:58531 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXLMXZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 18:25:35 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1359350wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2007 15:25:34 -0800 (PST)
Message-ID: <1ba2fa240712131525o6c0767e8je8a4feff21fbae69@mail.gmail.com> (sfid-20071213_232539_488510_61DD057C)
Date: Fri, 14 Dec 2007 01:25:34 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [FYI] hostapd with mac80211 progress
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>, hostap <hostap@shmoo.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1197567415.8313.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197512614.6558.224.camel@johannes.berg>
	 <1ba2fa240712130635n44838ac4s5bb606e5dc27fdeb@mail.gmail.com>
	 <1197567415.8313.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 13, 2007 7:36 PM, Johannes Berg <johannes@sipsolutions.net> wrote:

>Not sure if I really want to, maybe we can convince Jouni to take
>patches early if they don't break anything else?

That's probably the best option as more people are looking there so
we've might receive more exposure and get fast response.

> Oh btw, will you be publishing driver updates to support AP mode in
> iwlwifi? You must have them anyway if you're working on this and I'd
> love have a second driver capable of AP mode in the kernel.

We have frozen the AP stack before you've removed management interface
so first we have to rebase it to the current code, but it's being done
it will all go through this mailing list

Thanks
Tomas

>
