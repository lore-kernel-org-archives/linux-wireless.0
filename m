Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:36711 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964968AbbLQN05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 08:26:57 -0500
Received: by mail-qg0-f49.google.com with SMTP id c96so7113431qgd.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 05:26:57 -0800 (PST)
Date: Thu, 17 Dec 2015 08:26:55 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "Adam R. Welle" <arwelle@cert.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
Message-ID: <20151217132655.GA969@localhost> (sfid-20151217_142705_081205_EC4F2B9F)
References: <5670DA9A.4010102@candelatech.com>
 <1450257464.3159.1.camel@sipsolutions.net>
 <56716386.4070107@candelatech.com>
 <1450272308.8247.11.camel@sipsolutions.net>
 <567168AF.4060804@candelatech.com>
 <1450273362.8247.15.camel@sipsolutions.net>
 <2DE9F46DD36D2A458CD6347950113F2535C1ED@marathon>
 <5671E23A.1070502@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5671E23A.1070502@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 16, 2015 at 02:14:18PM -0800, Ben Greear wrote:
> On 12/16/2015 09:30 AM, Adam R. Welle wrote:
> >
> >>Well, it was always rather awkward since it was the *second* address :)
> >
> >Could somebody provide background information on why the decision was
> >made to use a second address for the netlink frames instead of the same
> >address as was used for the non-netlink frames?
> 
> I would be fine with always using the first address instead of the second,
> in case that helps someone.

It doesn't really, that would break old wmediumd.

> We could also set the address at creation time easily enough.  Then it
> could still be unique across many machines if you managed it.

We already have a way to change mac addresses; adding a new API to change
the default address seems pointless to me.

-- 
Bob Copeland %% http://bobcopeland.com/
