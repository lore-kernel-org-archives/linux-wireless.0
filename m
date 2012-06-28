Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48777 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab2F1JrP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:47:15 -0400
Message-ID: <4FEC2820.10709@tieto.com> (sfid-20120628_114718_679345_1F17F9BD)
Date: Thu, 28 Jun 2012 11:47:12 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] initial channel context implementation
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>       <1340718188.14634.47.camel@jlt3.sipsolutions.net>       <4FEAB698.5070309@tieto.com>      <1340784614.8305.8.camel@jlt3.sipsolutions.net>      <4FEADCAE.5080508@tieto.com>     <1340795424.11012.11.camel@jlt3.sipsolutions.net>     <4FEAFFF1.7080706@tieto.com>    <1340805730.11012.33.camel@jlt3.sipsolutions.net>    <4FEBF3D4.3030705@tieto.com>   <1340868682.4491.1.camel@jlt3.sipsolutions.net>   <4FEC0D9F.9030000@tieto.com>  <1340871180.4491.16.camel@jlt3.sipsolutions.net>  <4FEC21DA.9040901@tieto.com> <1340875646.4491.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340875646.4491.24.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-06-28 at 11:20 +0200, Michal Kazior wrote:
>>> Maybe it's worth fixing that first, and getting rid of *most* instances
>>> of hw.conf.channel, so we have a clearer idea of which changes in what
>>> ways?
>>
>> Sounds like a good idea.
>
> Do you want to take that up? I think it would be worth doing it in front
> of all the other mac80211 patches (those are incomplete anyway in that
> the new code doesn't get used), and then we can shake out any bugs here
> before we switch over to multi-channel?

Sure, I'll take it up.


-- 
Pozdrawiam / Best regards, Michal Kazior.

