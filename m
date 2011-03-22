Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab1CVNfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 09:35:36 -0400
Subject: Re: [PATCH 0/4] Add station BSS parameters to station
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110321213812.76CD420891@glenhelen.mtv.corp.google.com>
References: <20110321213812.76CD420891@glenhelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 14:35:33 +0100
Message-ID: <1300800933.3746.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 14:32 -0700, Paul Stewart wrote:
> This allows user-space monitoring of BSS parameters for the associated
> station.  This is useful for debugging and verifying that the paramaters
> are as expected.

Nice set of patches, but I'm wondering if the station info really is the
best place to put this information? It's not really strictly information
about the station, but rather about the BSS that it created. OTOH, I'm
not sure if we need to distinguish?

johannes

