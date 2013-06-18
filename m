Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab3FRMdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 08:33:01 -0400
Message-ID: <1371558772.8318.11.camel@jlt4.sipsolutions.net> (sfid-20130618_143306_047911_8DA6B994)
Subject: Re: [PATCH] nl80211: allow to register for mgmt frames without a
 matching pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 18 Jun 2013 14:32:52 +0200
In-Reply-To: <1371558554-367-1-git-send-email-ordex@autistici.org>
References: <1371558554-367-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 14:29 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> It may be the case that a user wants to register for any
> frame of a particular type.
> 
> Allow this operation by passing null as matching pattern and
> 0 as pattern len when registering for the frame.
> 
> This is useful to wpa_supplicant when it wants to receive
> any AUTH frame.

We can (and do) pass a 0-length pattern, any problem with that?

johannes

