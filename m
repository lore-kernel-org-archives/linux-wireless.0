Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaA2MRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 07:17:17 -0500
Message-ID: <1390997834.4143.7.camel@jlt4.sipsolutions.net> (sfid-20140129_131732_408637_5FF37712)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute
 confusion
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Date: Wed, 29 Jan 2014 13:17:14 +0100
In-Reply-To: <CAB3XZEczgVTALA3_4hSBikJs=TXOhHHTHSLzmuU3MGot-hG+1g@mail.gmail.com> (sfid-20140127_103726_726110_C367B2C8)
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEc94pTAMXWPYeWhu7o_YLEnD1_9O035-+YXYiR0Uij28w@mail.gmail.com>
	 <1390810765.4251.0.camel@jlt4.sipsolutions.net>
	 <CAB3XZEczgVTALA3_4hSBikJs=TXOhHHTHSLzmuU3MGot-hG+1g@mail.gmail.com>
	 (sfid-20140127_103726_726110_C367B2C8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-27 at 11:37 +0200, Eliad Peller wrote:

> > I don't think that's true? I looked at the drivers that use this and
> > they all skip empty SSIDs, except the one that I fixed.
> >
> ok. so at least fix the documentation? :)

Umm, ok :)

johannes

