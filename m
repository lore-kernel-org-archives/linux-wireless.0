Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wp071.webpack.hosteurope.de ([80.237.132.78]:41389 "EHLO
	wp071.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756513Ab3HMJWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 05:22:00 -0400
Message-ID: <5209FAB6.5050602@skbx.de> (sfid-20130813_112204_159592_5D61EFAD)
Date: Tue, 13 Aug 2013 11:21:58 +0200
From: "Volker von Hoesslin @ SKBX Systems" <hoesslin.v@skbx.de>
MIME-Version: 1.0
To: "Wright, Brett" <Brett.Wright@cooperindustries.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 80211s with DFS
References: <5207FC2A.4040207@skbx.de> <475A4E02EFF4724A9E58F55A56AC131608CDEF2D@APEVS1.ap.ci.root>
In-Reply-To: <475A4E02EFF4724A9E58F55A56AC131608CDEF2D@APEVS1.ap.ci.root>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The real difficulty with DFS and 802.11s is what happens when a radar is
> detected? All mesh nodes need to be on the same channel, so there needs
> to be some consistent way of propagating a channel switch announcement
> to all wireless nodes.
>

indeed, thats a hard question. my first hint is looking at cisco 
(http://www.cisco.com/en/US/docs/wireless/technology/mesh/7.0/design/guide/MeshAP_70.pdf 
-> page 169), but 80211s has't a RAP so maybe there are only some tips 
for a workflow.

i think there are diffrent possibilities:

1. the MAP that has a radar detection go sleep and wait till the channel 
is clear to come back -> mesh will down :/
2. the mesh has to negotiate a new free channel via bacon-frames, maybe 
generating preventively a list of  channel for switching?
3. some other ideas ?

is there someone at work for a DFS implementation?

volker...
