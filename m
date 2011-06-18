Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1FRIBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 04:01:36 -0400
To: =?UTF-8?Q?Fr=C3=A9d=C3=A9ric_Lamorce?= <FLamorce@CalAmp.com>
Subject: Re: nl80211: =?UTF-8?Q?set=5Fkey=20failed=3B=20err=3D-=36=37=20Li?=  =?UTF-8?Q?nk=20has=20been=20severed?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Sat, 18 Jun 2011 10:01:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4065B927@oxn-mx01.PD.CalAmpCorp.com>
 (sfid-20110617_172355_144137_7070136A)
References: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4065B927@oxn-mx01.PD.CalAmpCorp.com>
 (sfid-20110617_172355_144137_7070136A)
Message-ID: <39e83b34879f7b3d79534665e9dd0ae6@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 17 Jun 2011 08:23:47 -0700, Frédéric Lamorce wrote:

> I enabled -dd with wpa_supplicant, here it is, the only error is
> "nl80211: set_key failed; err=-67 Link has been severed)", fatal? Why
> this error? It means the link is down?

You can ignore that error. Below is the successful key setting: Problem 
must be something else, maybe crypto code for your device or whatever.

> 14532.914745: wpa_driver_nl80211_set_key: ifindex=5 alg=1
> addr=0xc3aec key_idx=0 set_tx=1 seq_len=0 key_len=5

