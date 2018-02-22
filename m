Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46374 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbeBVUWI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 15:22:08 -0500
Message-ID: <1519330924.2637.18.camel@sipsolutions.net> (sfid-20180222_212212_368183_475B09B2)
Subject: Re: pull-request: mac80211-next 2018-02-22
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 22 Feb 2018 21:22:04 +0100
In-Reply-To: <20180222.151902.347947675667607885.davem@davemloft.net>
References: <20180222201619.30037-1-johannes@sipsolutions.net>
         <20180222.151902.347947675667607885.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-02-22 at 15:19 -0500, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu, 22 Feb 2018 21:16:18 +0100
> 
> > Wireless is slow ... but we're preparing for HE (802.11ax),
> > so I guess soon we'll have a big chunk of work coming :-)
> 
> I wondered where you guys have been hiding :-)

Yeah, I don't like this development model much, but the spec isn't
finished yet and every time I look at an area I end up changing it
*again* which isn't fun to do upstream :-)

(Was just doing the HE sniffer stuff in radiotap these days ... uh,
yeah, I've more or less rewritten it twice already - hopefully no more)

johannes
