Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50037 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374Ab2FLLUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 07:20:35 -0400
Received: by lahd3 with SMTP id d3so3415066lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 04:20:34 -0700 (PDT)
Message-ID: <4FD725FF.1030108@gmail.com> (sfid-20120612_132039_089213_B1A0521A)
Date: Tue, 12 Jun 2012 13:20:31 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Disallow changing chan type on monitor when
 CHAN_MODE_FIXED
References: <1339499167-26225-1-git-send-email-pontus.fuchs@gmail.com>  (sfid-20120612_130639_458885_983B325C) <1339499291.4531.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339499291.4531.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-12 13:08, Johannes Berg wrote:
> If you add a monitor interface in paralell to a normal interface
> mac80211 will let you to change the channel type on the monitor
> interface even if you are connected. Add an explicit check to
> disallow this.
> Is this against 3.5, and is it really needed there? It's a corner case
> to start with.
It's against wireless-next. It's a real corner case indeed. With the
wireshark toolbar I create monitors on demand for all phy's so I
see it quite often myself. If it needs fixing is up to you to decide :)

Cheers,

Pontus

