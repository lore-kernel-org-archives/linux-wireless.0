Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3AaOZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 09:25:50 -0500
Message-ID: <1359642373.8415.57.camel@jlt4.sipsolutions.net> (sfid-20130131_152552_851235_FF17DAC9)
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH
 response
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Date: Thu, 31 Jan 2013 15:26:13 +0100
In-Reply-To: <510A7D40.2030206@lri.fr>
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
	    <1355146824-25012-2-git-send-email-antonio@open-mesh.com>
	    <1356706268.9922.23.camel@jlt4.sipsolutions.net>
	    <20130102063255.GA27676@open-mesh.com> <50E400A7.5060100@lri.fr>
	    <20130107114048.GH27589@ritirata.org> <50EACA95.8040004@lri.fr>
	   <1359151524.4655.37.camel@jlt4.sipsolutions.net>
	 <5103C774.4080403@lri.fr>  <1359459469.8108.11.camel@jlt4.sipsolutions.net>
	 <5107D5D5.3070601@lri.fr> <1359639241.8415.17.camel@jlt4.sipsolutions.net>
	 <510A7D40.2030206@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 15:18 +0100, Nicolas Cavallari wrote:

> > I think that's acceptable, but if it requires a wpa_s change anyway we
> > could just implement reboot detection there instead of adding all these
> > new events etc.? I.e. rather than having a new supplicant say "OK I will
> > listen to the right event when handling reboot detection", it could just
> > use the existing infrastructure and implement it itself?
> 
> Well i already have wpa_supplicant patches for that. Might just need to clean that up a
> bit so it's at least configurable.
> 
> But now i'm reminded that transmitting management frames from userspace requires a
> frequency. For wpasupp to be race-free during ibss merges, we should have a way to
> transmit management frames to the current bss without specifying a frequency...

That seems reasonable.

johannes

