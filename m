Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cooperlighting-sw.cooperlighting.com ([216.130.131.68]:41732
	"EHLO cooperlighting-sw.cooperlighting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756533Ab3HMBvQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 21:51:16 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: 80211s with DFS
Date: Tue, 13 Aug 2013 09:33:18 +0800
Message-ID: <475A4E02EFF4724A9E58F55A56AC131608CDEF2D@APEVS1.ap.ci.root> (sfid-20130813_035119_416321_41A6702E)
In-Reply-To: <5207FC2A.4040207@skbx.de>
References: <5207FC2A.4040207@skbx.de>
From: "Wright, Brett" <Brett.Wright@cooperindustries.com>
To: "Volker von Hoesslin @ SKBX Systems" <hoesslin.v@skbx.de>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Volker von Hoesslin @ SKBX Systems

> i have a real big problem! i'm trying to implement a wireless-mesh
> (80211s) with openWRT (current trunk) over 11a (5GHz) with "authSAE"
for
> outdoor. all works fine, mesh is runnning and all fine. but now, i'm
at
> germany and for the outdoor use, i have to use the channel 100-140
with DFS
> & TPC. so the mesh implementation dont work in this channel? with this
> error:
> 

Hi 

The real difficulty with DFS and 802.11s is what happens when a radar is
detected? All mesh nodes need to be on the same channel, so there needs
to be some consistent way of propagating a channel switch announcement
to all wireless nodes. 

Brett

