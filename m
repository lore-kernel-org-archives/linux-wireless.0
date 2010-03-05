Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:33405 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0CEAcm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 19:32:42 -0500
From: Bruno Randolf <br1@einfach.org>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] ath5k IBSS mode high latency
Date: Fri, 5 Mar 2010 09:32:25 +0900
Cc: Bob Copeland <me@bobcopeland.com>,
	Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4B8D37AC.4010000@nets.rwth-aachen.de> <b6c5339f1003030906jaa47f8dld615865b52bf19a1@mail.gmail.com>
In-Reply-To: <b6c5339f1003030906jaa47f8dld615865b52bf19a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003050932.26034.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 04 March 2010 02:06:26 Bob Copeland wrote:
> By the way, I did notice that if we fail to map DMA
> buffers we can leak tx descriptors, but this is unlikely
> to be the cause.

i have also seen the problem that we can run out of memory when there is a lot 
of traffic (UDP) to forward. i have that fairly reproducable here.

bruno
