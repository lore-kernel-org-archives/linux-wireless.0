Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0HBQX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 12:23:26 -0400
Subject: Re: iwlwifi connection problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <878w4pvx5e.fsf@sycorax.lbl.gov>
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	 <1279917523.10769.1.camel@wwguy-huron>
	 <1280135867.3693.5.camel@jlt3.sipsolutions.net>
	 <87mxtd5xlq.fsf@sycorax.lbl.gov>
	 <1280212629.19098.0.camel@jlt3.sipsolutions.net>
	 <87bp9l6f4k.fsf@sycorax.lbl.gov>
	 <1280746705.3923.11.camel@jlt3.sipsolutions.net>
	 <878w4pvx5e.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 18:23:21 +0200
Message-ID: <1280766201.24503.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-02 at 08:42 -0700, Alex Romosan wrote:

> so i think i finally managed to track this down. doing a git bisect i
> get:
> 
> 3474ad635db371b0d8d0ee40086f15d223d5b6a4 is the first bad commit
> commit 3474ad635db371b0d8d0ee40086f15d223d5b6a4
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Apr 29 04:43:05 2010 -0700
> 
>     iwlwifi: apply filter flags directly

> ...

Thanks. I'll take a closer look tomorrow, am about to leave for today.

johannes

