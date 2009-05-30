Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:36219 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbZE3BG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 21:06:56 -0400
Received: by yx-out-2324.google.com with SMTP id 3so3546858yxj.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2009 18:06:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090529220222.GA22246@god.dyndns.org>
References: <20090524222027.GA32198@god.dyndns.org>
	 <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com>
	 <20090527184956.GA14462@god.dyndns.org>
	 <20090528234702.GA9455@hash.localnet>
	 <20090529220222.GA22246@god.dyndns.org>
Date: Fri, 29 May 2009 21:06:57 -0400
Message-ID: <b6c5339f0905291806j4a7f99f4r9fb40a6a0182cf52@mail.gmail.com>
Subject: Re: ath5k in AP mode works!! (but sometimes with an oops, and a
	panic)
From: Bob Copeland <me@bobcopeland.com>
To: henk <henk@god.dyndns.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 29, 2009 at 6:02 PM, henk <henk@god.dyndns.org> wrote:
> Wouldn't it be better to reverse the deinitialisation? To make sure we
> dont hit an interrupt in between? Like:
>
>        ath5k_beacon_disable(sc);
>        ec->vif = NULL;

Yeah, actually I gave this some thought but I can't now rationalize
the current order, so maybe I just goofed.

-- 
Bob Copeland %% www.bobcopeland.com
