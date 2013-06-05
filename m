Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3FEG7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 02:59:50 -0400
Message-ID: <1370415586.8920.4.camel@jlt4.sipsolutions.net> (sfid-20130605_085953_537710_C5DC5D6F)
Subject: Re: wireless tree rebased (from 5/28), Broadcom bits dropped
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
	Luciano Coelho <coelho@ti.com>
Date: Wed, 05 Jun 2013 08:59:46 +0200
In-Reply-To: <20130604215320.GC11199@tuxdriver.com> (sfid-20130605_000022_753591_1B1E52D0)
References: <20130604212602.GB11199@tuxdriver.com>
	 <20130604215320.GC11199@tuxdriver.com>
	 (sfid-20130605_000022_753591_1B1E52D0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-04 at 17:53 -0400, John W. Linville wrote:
> I messed this up too -- bad day...
> 
> If you pulled in between the earlier message and this one, please
> do so again.  If you saw this message before taking any action to
> clean-up my mess, then you are OK.

This was confusing, I think you rebased around some merges instead of
redoing the merges? My patches are in, but suddenly got new commit IDs,
e.g. fa331699d05ce1d0d4896eb4a137cfae50d7afde (new) vs.
c2c15e215e860c99b86ddfc4be4bb25cf180fed0 for "mac80211: work around
broken APs not including HT info".

This will cause git to pull them in again when I send a new pull
request, so it would have been nicer to redo the merges, but anyway ...
just a heads-up for everyone that here it's a bit confusing now.

johannes

