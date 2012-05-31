Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54130 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab2EaCbp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 22:31:45 -0400
Received: by gglu4 with SMTP id u4so464895ggl.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 19:31:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWXF5AMQfSkoCBGWgB1sod6fOEqViDiFCif2hqLx55N0g@mail.gmail.com>
References: <1338430181-12490-1-git-send-email-yeohchunyeow@gmail.com>
	<CAGRGNgWXF5AMQfSkoCBGWgB1sod6fOEqViDiFCif2hqLx55N0g@mail.gmail.com>
Date: Thu, 31 May 2012 10:31:44 +0800
Message-ID: <CAEFj987H6wrN5ayRqh1QiE_OKbi_9bj1OCeFCrht0yKtkz0mqA@mail.gmail.com> (sfid-20120531_043148_621388_A607BE76)
Subject: Re: [PATCH] {nl,cfg,mac}80211: implement dot11MeshHWMPconfirmationInterval
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Julian

> This doesn't make sense.
>
> Is this what you're trying to say?
>
> "Minimum interval of time (in TUs) between sending Action frames
> containing PREQ elements for root path confirmation."

Hi, Julian

I have captured this directly from the standard. It actually means
that once the mesh STA receives the RANN, it can send the PREQ to the
root mesh STA if the the last PREQ to the root mesh STA was sent
dot11MeshHWMPconfirmationInterval TUs (or more) ago.

"This attribute specifies the minimum interval of time (in TUs) during
which a mesh STA can send only one Action frame containing a PREQ
element for root path confirmation."

Regards,
Chun-Yeow
