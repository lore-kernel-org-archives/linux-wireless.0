Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52491 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab0IJTvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 15:51:47 -0400
Message-ID: <4C8A8C50.30902@candelatech.com>
Date: Fri, 10 Sep 2010 12:51:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: RFC:  v2: Support multiple STA on same AP with ath9k
References: <4C8A8B96.5050409@candelatech.com>
In-Reply-To: <4C8A8B96.5050409@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2010 12:48 PM, Ben Greear wrote:
> The attached patch lets mac80111 create multiple STA on the same
> AP, and the changes to ath9k let it function properly, at least for
> un-encrypted traffic. WPA does not work..no idea why yet.
>
> It also consolidates some of the util.c iterator logic in
> mac80211.
>
> Please let me know if this is moving in the right direction.

Ummm, the second I hit send I noticed my consolidation of the helper
logic broke things because I'm always using the _rcu variant of
the for loop...will fix that.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

