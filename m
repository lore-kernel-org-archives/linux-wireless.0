Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1792 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052Ab0DWQlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 12:41:11 -0400
Date: Fri, 23 Apr 2010 12:37:03 -0400
From: me@bobcopeland.com
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Message-ID: <20100423163703.GB11112@hash.localnet>
References: <201004230806.13628.pedrogfrancisco@gmail.com> <20100423134823.GB5004@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100423134823.GB5004@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 23, 2010 at 09:48:23AM -0400, John W. Linville wrote:
> > a) is it "normal"? I thought modules were somewhat isolated these days.
> > b) any advices for debugging? I've yet to have two oopses that are similar....

Advice for debugging: turn on slub/slab debug options, and possibly
kmemcheck.  kmemcheck was very helpful for me last time I had such
a corruption issue.

-- 
Bob Copeland %% www.bobcopeland.com

