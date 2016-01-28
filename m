Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36746 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbcA1PIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 10:08:23 -0500
Received: by mail-lf0-f67.google.com with SMTP id t141so2239844lfd.3
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2016 07:08:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160128134415.GA24581@localhost>
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <20160128134415.GA24581@localhost>
From: Henning Rogge <hrogge@gmail.com>
Date: Thu, 28 Jan 2016 16:07:52 +0100
Message-ID: <CAGnRvupPyh=+UF11KobqnSfP=J4JuKqugrmD=wC+ZP2pXgw-iQ@mail.gmail.com> (sfid-20160128_160828_240127_DF40350B)
Subject: Re: [PATCH 0/2] mac80211: add cleanup path for MPP table entries
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2016 at 2:44 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Jan 19, 2016 at 09:04:30AM +0100, Henning Rogge wrote:
>> Currently MPP table entries are only removed from memory when their
>> 802.11s mesh interface goes down. This can make the kernel to remember
>> a growing list of proxied mac addresses which are not relevant or even
>> reachable anymore.
>
> Just so I know what to do with my series: do you plan to resend these
> with comments addressed?  Or I could adopt the patches if you want.

What would be easier for you?

I can easily resend a "v2" tomorrow, depends on how much work it would
be for you to integrate them (or adapt them) to your patch set.

Henning
