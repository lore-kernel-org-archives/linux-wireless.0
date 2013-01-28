Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60045 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab3A1KeG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 05:34:06 -0500
Received: from ilfaris ([84.113.227.159]) by smtp.web.de (mrweb002) with
 ESMTPSA (Nemesis) id 0LqlAw-1UcwbW3u3G-00dq41 for
 <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2013 11:34:05 +0100
Date: Mon, 28 Jan 2013 11:34:02 +0100
From: Julian Wollrath <jwollrath@web.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Warning with trace while trying to connect to an AP
Message-ID: <20130128113402.54809556@ilfaris> (sfid-20130128_113411_686326_3633F6A3)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

> On Sun, 2012-12-23 at 14:34 +0100, Julian Wollrath wrote:
> > Hello,
> > 
> > while trying to connect to an AP I got the following trace:
> > [13677.506164] ------------[ cut here ]------------
> > [13677.506196] WARNING: at net/wireless/mlme.c:517
> > cfg80211_mlme_disassoc+0x17d/0x190 [cfg80211]()
> 
> Are you able to reproduce this by any chance? It's been happening for
> a while, but I've so far been unable to figure out what causes
> "wdev->sme_state" and "wdev->current_bss" to get out of sync ...
Sorry, it only happend with the wireless network I tried to connect to
while I was on vacation. I was not able to reproduce it since but as
soon as I can reproduce it I while tell you.


With best regards,
Julian
