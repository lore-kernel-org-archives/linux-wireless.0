Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50027 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1EDRby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 13:31:54 -0400
Received: by vxi39 with SMTP id 39so1385580vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 10:31:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304529914.3563.25.camel@jlt3.sipsolutions.net>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
 <1304467039-7730-14-git-send-email-javier@cozybit.com> <4DC165D7.50403@openwrt.org>
 <BANLkTikOOvGfzV4YK6_0LWnF3jFQy-N0ig@mail.gmail.com> <1304529914.3563.25.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 4 May 2011 10:31:34 -0700
Message-ID: <BANLkTikd_7zu5X1CWyVxxNqeS3BMQsJacA@mail.gmail.com> (sfid-20110504_193157_679401_D50010B4)
Subject: Re: [PATCH 13/13] ath9k: fix beaconing for mesh interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2011 at 10:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-05-04 at 10:13 -0700, Javier Cardona wrote:
>
>> The current version of the draft defines a different beaconing mode
>> specific for mesh.
>
> Out of curiosity, what does that mode look like?

Similar to AP mode (fixed beaconing period) but with a mechanism to
avoid collisions (Mesh Beaconing Collision Avoidance).

Javier
