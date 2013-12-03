Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3LCJqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 04:46:05 -0500
Message-ID: <1386063957.4393.4.camel@jlt4.sipsolutions.net> (sfid-20131203_104613_236457_28C579A3)
Subject: Re: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 03 Dec 2013 10:45:57 +0100
In-Reply-To: <529DA7FB.6020600@lri.fr>
References: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
	 <529DA7FB.6020600@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 10:44 +0100, Nicolas Cavallari wrote:
> On 02/12/2013 19:51, Johannes Berg wrote:
> > +			if (!ipv4_is_multicast(ip.hdr4.daddr))
> > +				return -1;
> 
> So broadcasting to e.g. 192.168.255.255 is now forbidden ?

Please, read the patch :)

johannes

