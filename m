Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3JAKRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 06:17:03 -0400
Message-ID: <1380622620.14430.4.camel@jlt4.sipsolutions.net> (sfid-20131001_121706_933700_A71A85CD)
Subject: Re: [PATCH 2/3] ieee80211: fix vht cap definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Date: Tue, 01 Oct 2013 12:17:00 +0200
In-Reply-To: <1377852561-16754-2-git-send-email-johannes@sipsolutions.net> (sfid-20130830_104933_745876_8986D88D)
References: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net>
	 <1377852561-16754-2-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130830_104933_745876_8986D88D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-30 at 10:49 +0200, Johannes Berg wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> VHT_CAP_BEAMFORMER_ANTENNAS cap is actually defined in the draft as
> VHT_CAP_BEAMFORMEE_STS_MAX, and its size is 3 bits long.
> 
> VHT_CAP_SOUNDING_DIMENSIONS is also 3 bits long.
> 
> Fix the definitions and change the cap masking accordingly.

Applied.

johannes

