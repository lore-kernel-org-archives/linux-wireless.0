Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52191 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaIHMZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 08:25:49 -0400
Received: by mail-ie0-f169.google.com with SMTP id rl12so1985191iec.28
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 05:25:48 -0700 (PDT)
Date: Mon, 8 Sep 2014 08:24:54 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>, devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: Re: [PATCH] {nl, cfg, mac}80211: Implement hidden mesh ID
Message-ID: <20140908122454.GA29495@localhost> (sfid-20140908_142552_448704_899B6E0D)
References: <1410156082-17313-1-git-send-email-yeohchunyeow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1410156082-17313-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2014 at 02:01:22PM +0800, Chun-Yeow Yeoh via Devel wrote:
> The hidden mesh ID is use to enhance the security of
> open mesh and possible secured mesh later on by not
> advertising the mesh ID during beacon generation,
> similar to hidden SSID implemented in AP mode.

I'm unconvinced - hidden SSID is not much of a security feature and it
seems like this would break all manner of things.  Is it really worth
the pain when people can just use a secure mesh instead?

-- 
Bob Copeland %% www.bobcopeland.com
