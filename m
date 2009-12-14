Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52446
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755783AbZLNMk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 07:40:26 -0500
Date: Mon, 14 Dec 2009 04:40:27 -0800 (PST)
Message-Id: <20091214.044027.35344301.davem@davemloft.net>
To: luciano.coelho@nokia.com
Cc: linville@tuxdriver.com, mcgrof@gmail.com, kalle.valo@iki.fi,
	linux-wireless@vger.kernel.org
Subject: Re: Revised wireless tree management practices
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B263063.4030000@nokia.com>
References: <43e72e890912100814u45a58c47j5dfd66769f8170b@mail.gmail.com>
	<20091210162517.GD2955@tuxdriver.com>
	<4B263063.4030000@nokia.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>
Date: Mon, 14 Dec 2009 14:32:35 +0200

> Now it's my turn to ask a question... What happens in the case when
> there is an API change, say, in mac80211 that requires changes in a
> few different drivers? Those changes are usually done in a single
> patch that changes both the API and the affected drivers in one go.
> In this case we will end up having to rebase our own trees.

No you won't need to rebase, that's the last thing you should do.

When there is a conflict to resolve or a situation like the one you
describe, you simply pull John's tree into your's.
