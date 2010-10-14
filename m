Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0JNOu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 10:50:26 -0400
Subject: Re: [PATCH 3/6] Add a function for evaluating rate changes for
 possible notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1287066750.4641.439.camel@jlt3.sipsolutions.net>
References: <20101013224851.B8E5D20465@glenhelen.mtv.corp.google.com>
	 <1287064265.4641.435.camel@jlt3.sipsolutions.net>
	 <AANLkTinq=B13gPd3obqAkBDQv4Ufz5Upp2UPVw9bpED2@mail.gmail.com>
	 <1287066750.4641.439.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 16:51:09 +0200
Message-ID: <1287067869.4641.440.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 16:32 +0200, Johannes Berg wrote:

> I wonder if "rate" is really the best interface for this. Since it's a
> threshold event, does it matter? Maybe there should instead be events
> for MCS changes and legacy rate changes so we can avoid all those
> calculations?

In fact, since you'd only care about changes across a threshold etc, not
the absolute rate, you might be able to build the system without ever
doing the expensive rate calculation from MCS.

johannes

