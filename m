Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33006 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaBFRQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 12:16:49 -0500
Received: by mail-ie0-f170.google.com with SMTP id u16so840330iet.15
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 09:16:49 -0800 (PST)
Date: Thu, 6 Feb 2014 12:16:06 -0500
From: Bob Copeland <me@bobcopeland.com>
To: James Cameron <quozl@laptop.org>
Cc: Giuseppe Siracusano <a_siracusano@tin.it>,
	linux-wireless@vger.kernel.org
Subject: Re: Reduce tx power
Message-ID: <20140206171606.GC20719@localhost> (sfid-20140206_181653_264002_939D07A8)
References: <1391599819.4118.3.camel@Core2>
 <20140205204013.GA29649@us.netrek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140205204013.GA29649@us.netrek.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 06, 2014 at 07:40:14AM +1100, James Cameron wrote:
> I don't know about ath5k, but in usb8388 firmware (libertas driver)
> there is a blinding table, into which MAC addresses were inserted, so
> that the firmware would simulate test conditions.

At least in the mac80211 11s mesh implementation (and thus available
with ath5k), the equivalent is plink block, which restricts peering
between neighbors:

 $ iw mesh0 station set <MAC address> plink_action block

-- 
Bob Copeland %% www.bobcopeland.com
