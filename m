Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42758 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2DPSDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 14:03:34 -0400
MIME-Version: 1.0
In-Reply-To: <4F8C59B2.20207@candelatech.com>
References: <1334248689-23018-1-git-send-email-greearb@candelatech.com>
	<4F8C57CC.4090505@sipsolutions.net>
	<4F8C59B2.20207@candelatech.com>
Date: Mon, 16 Apr 2012 11:03:33 -0700
Message-ID: <CAJ-VmokfxVEekHSuKP4KxgAGbK6S8z_vuOOYb=W3cERMmHvdKQ@mail.gmail.com> (sfid-20120416_200339_131000_DD3E2682)
Subject: Re: [PATCH v3] mac80211: Support on-channel scan option.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 April 2012 10:41, Ben Greear <greearb@candelatech.com> wrote:

> I also tried some manual scans on a fixed frequency.  Those
> appeared to work, though I got scan results for APs on different
> channels.  Does that seem right?  I can't see how my patch
> would affect that sort of thing one way or another...

You'll see off-channel beacons in 11bg mode. :-)

It's actually rather helpful, except that the RSSI reported isn't
anywhere near as valid as you'd like.



Adrian
