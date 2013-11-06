Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab3KFKJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:09:28 -0500
Message-ID: <1383732564.14307.16.camel@jlt4.sipsolutions.net> (sfid-20131106_110931_784182_AA1B4FEC)
Subject: Re: [PATCH v2 1/5] cfg80211/mac80211: DFS setup chandef for cac
 event
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 11:09:24 +0100
In-Reply-To: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144902_417014_74E30BCC)
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131105_144902_417014_74E30BCC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-05 at 14:48 +0100, Janusz Dziedzic wrote:

>  void cfg80211_cac_event(struct net_device *netdev,
> +			struct cfg80211_chan_def *chandef,

Jouni had a patch to make a lot of these pointers const - this one
probably should be as well.

johannes


