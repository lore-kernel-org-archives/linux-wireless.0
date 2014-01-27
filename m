Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49245 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaA0Nel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 08:34:41 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Sujith Manoharan <sujith@msujith.org>
Subject: Re: IBSS can't beacon after rejoin / regression in TSF syncing code?
Date: Mon, 27 Jan 2014 14:34:37 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>
References: <201401241826.45121.sw@simonwunderlich.de> <21221.57261.792711.70974@gargle.gargle.HOWL> <201401271427.51372.sw@simonwunderlich.de>
In-Reply-To: <201401271427.51372.sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201401271434.37513.sw@simonwunderlich.de> (sfid-20140127_143444_140753_2826A42E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm CCing Teemu, who introduced this roughly 3.5 years ago ("mac80211:
> remove BSS from cfg80211 list when leaving IBSS",
> 5ea096c0c85e80335889539899af9a4717976e0b) , maybe he can explain it more. 
> I couldn't understand that from the commit message and the corresponding
> mail thread.
> 
> If we don't hear anything or there aren't any further objections, I think
> we can clean this patch and merge it. :)

Nokias mailserver just told me that Teemus e-mail address isn't registered, so 
I guess we shouldn't wait for him. :)
