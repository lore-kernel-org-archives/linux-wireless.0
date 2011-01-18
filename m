Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20339 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab1AROKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 09:10:54 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 06:10:36 -0800
Date: Tue, 18 Jan 2011 19:40:05 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: reset connection poll on receiving unicast data
 frames
Message-ID: <20110118141005.GA9395@vmraj-lnx.users.atheros.com>
References: <1295358285-9336-1-git-send-email-rmanoharan@atheros.com>
 <1295358680.3563.21.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1295358680.3563.21.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 18, 2011 at 07:21:20PM +0530, Johannes Berg wrote:
> On Tue, 2011-01-18 at 19:14 +0530, Rajkumar Manoharan wrote:
> > In noisy channel conditions, some APs do not reply to probe
> > requests which results in STA disconnection. It is perfectly
> > fine to reset the connection polling if unicast frames are
> > received from that AP properly.
> 
> I'm not convinced. We often have no trouble hearing the AP but the AP
> isn't hearing us because sensitivity is different etc.
>
But it does affect data transmission. STA is continuously receiving
data from AP. So we can ensure that connection is still alive
based on unicast frame though STA is not hearing probe response.

--
Rajkumar
