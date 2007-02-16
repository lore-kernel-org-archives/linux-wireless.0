Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48748 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbXBPMDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 07:03:44 -0500
Date: Fri, 16 Feb 2007 13:03:29 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] d80211: Add software sequence support
Message-ID: <20070216130329.5f1dffee@griffin.suse.cz>
In-Reply-To: <20070215215722.3db7f3ca@griffin.suse.cz>
References: <200702141423.27823.IvDoorn@gmail.com>
	<200702151548.25041.flamingice@sourmilk.net>
	<20070215215722.3db7f3ca@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 15 Feb 2007 21:57:22 +0100, Jiri Benc wrote:
> Thinking about it more, sdata should be the correct place. It's more
> per-interface thing than per-BSS (although the difference is small in
> this particular case).

...and thinking about it even more, that won't work with WDS.

 Jiri

-- 
Jiri Benc
SUSE Labs
