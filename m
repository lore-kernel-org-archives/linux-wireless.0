Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49903 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaIHMfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 08:35:25 -0400
Received: by mail-vc0-f181.google.com with SMTP id ij19so1587138vcb.26
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 05:35:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140908122454.GA29495@localhost>
References: <1410156082-17313-1-git-send-email-yeohchunyeow@gmail.com>
	<20140908122454.GA29495@localhost>
Date: Mon, 8 Sep 2014 20:35:24 +0800
Message-ID: <CAEFj984GD-grKyw8Ku4_CCWH5-aZzaMBmhZ4ifdkADnKu9B65g@mail.gmail.com> (sfid-20140908_143534_646896_B39809D1)
Subject: Re: [PATCH] {nl, cfg, mac}80211: Implement hidden mesh ID
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2014 at 8:24 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Sep 08, 2014 at 02:01:22PM +0800, Chun-Yeow Yeoh via Devel wrote:
>> The hidden mesh ID is use to enhance the security of
>> open mesh and possible secured mesh later on by not
>> advertising the mesh ID during beacon generation,
>> similar to hidden SSID implemented in AP mode.
>
> I'm unconvinced - hidden SSID is not much of a security feature and it
> seems like this would break all manner of things.  Is it really worth
> the pain when people can just use a secure mesh instead?
>

Yes, I agreed that this is not really a security feature. But I think
that hidden mesh ID could provide a layer of protection to our mesh
network, especially open mesh. For your information, by default this
feature is turned off and only worked if user intended to have this.

---
Chun-Yeow
