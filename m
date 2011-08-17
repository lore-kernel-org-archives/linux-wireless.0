Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab1HQQgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 12:36:43 -0400
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: ~3.1-rc1 mac80211 =?UTF-8?Q?regression=3F=20NULL=20pointer=20?=  =?UTF-8?Q?dereference=2C=20memcpy=2C=20nla=5Fput?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Wed, 17 Aug 2011 18:36:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <CACna6rzdoAgoW8B11bpdqNAi1Gz2T6AV4g-m5WGz9X0izhCDOQ@mail.gmail.com>
 (sfid-20110817_181438_086831_98729AB8)
References: <CACna6rzdoAgoW8B11bpdqNAi1Gz2T6AV4g-m5WGz9X0izhCDOQ@mail.gmail.com>
 (sfid-20110817_181438_086831_98729AB8)
Message-ID: <599203fe1d78132e3855f9626db7817b@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 17 Aug 2011 18:14:32 +0200, Rafał Miłecki wrote:
> I've problem with my BCM43224 and BCM43225 cards. They stopped to 
> work
> around 3.1-rc1 and I suspect it's mac80211 regression.

Already fixed in wireless-testing, but I don't remember the patch 
title.

johannes
