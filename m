Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.246]:63349 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYDWAso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 20:48:44 -0400
Received: by hs-out-0708.google.com with SMTP id 4so1402004hsl.5
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2008 17:48:43 -0700 (PDT)
Subject: Re: mesh point beacon sending problem for 802.11s
From: Luis Carlos Cobo <luisca@cozybit.com>
To: cao jing <caojing.china@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9f33c5230804152338va7a9118tdd869f2196a6742b@mail.gmail.com>
References: <9f33c5230804152338va7a9118tdd869f2196a6742b@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 17:48:39 -0700
Message-Id: <1208911719.13800.2.camel@localhost> (sfid-20080423_024926_153814_70BB6664)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-16 at 02:38 -0400, cao jing wrote:
> Hi,
> 
> Open11s developers said it's already supported the Mesh peer link
> establishment. But I can't find any code for mesh point to send
> beacons. How come the mesh point establish a peer link without
> beacons.

That you did not find the code does not necessarily means it is not
there ;-). Check out net/mac80211/tx.c:ieee80211_beacon_get()

I assume you are looking at wireless-testing.

Cheers!

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


