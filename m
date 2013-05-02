Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3EBKGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 06:06:08 -0400
Message-ID: <1367489163.8298.2.camel@jlt4.sipsolutions.net> (sfid-20130502_120612_307968_96893E78)
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 02 May 2013 12:06:03 +0200
In-Reply-To: <51823A0E.8020005@broadcom.com>
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
	 <51823A0E.8020005@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-02 at 12:03 +0200, Arend van Spriel wrote:

> I tested the patch on x86 platform and was successful executing a 
> p2p_find, p2p_connect, and able to ping my peer. But....
> 
> When I tried this a second time I got a lockdep warning about annotation 
> as brcmfmac tried to take a mutex during scan (p2p_find). Two minutes 
> later I got warning about rcu stalls. Not sure where to look.

Me neither? :) What does it say?

johannes

