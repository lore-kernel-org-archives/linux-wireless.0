Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0CRSMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 14:12:14 -0400
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in
 ieee80211_local data structure
From: Johannes Berg <johannes@sipsolutions.net>
To: "lorenzo.bianconi83@gmail.com" <lorenzo.bianconi@fluidmesh.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	br1@einfach.org, ht6100@gmail.com
In-Reply-To: <4BA24A12.4030208@gmail.com>
References: <4BA24A12.4030208@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 11:12:13 -0700
Message-ID: <1268935933.4005.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I think I see the problem, but this is not the right thing to do.
The problem would seem to be synchronisation issues, I'll try to come up
with a fix.

johannes

