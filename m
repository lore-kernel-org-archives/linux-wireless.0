Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3KLTqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 14:46:46 -0500
Message-ID: <1384285594.14301.10.camel@jlt4.sipsolutions.net> (sfid-20131112_204657_702248_C3EFC46D)
Subject: Re: Association often fails first time when roaming with 802.11r.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 12 Nov 2013 20:46:34 +0100
In-Reply-To: <52828324.3060105@candelatech.com>
References: <52828324.3060105@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-12 at 11:36 -0800, Ben Greear wrote:

> 1384284459.394826: sta1: Considering connect request: reassociate: 1  selected: dc:a5:f4:ff:4f:ad  bssid: dc:a5:f4:ff:4f:ad  pending: 00:00:00:00:00:00

You hacked those messages?

> 1384284459.394835: sta1: Request association: reassociate: 1  selected: dc:a5:f4:ff:4f:ad  bssid: dc:a5:f4:ff:4f:ad  pending: 00:00:00:00:00:00  wpa_state:

I don't see this one upstream.

> 1384284459.396010: sta1: nl80211: MLME command failed (auth): ret=-114 (Operation already in progress)

This is typically the case when you're already connected to the AP, and
in the log above the new/old BSSID seem identical?

johannes

