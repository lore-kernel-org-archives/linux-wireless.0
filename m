Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:34140 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767836AbXCJOjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2007 09:39:12 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1673828uga
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2007 06:39:10 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Sat, 10 Mar 2007 15:38:54 +0100
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com> <20070219204004.6730a17a@griffin.suse.cz> <1171914770.15489.5.camel@johannes.berg>
In-Reply-To: <1171914770.15489.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703101538.55267.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > If we consider this as a problem later, we can always change to per-MAC
> > address counters or something as it's completely internal to the stack
> > and no driver changes would be required.
> 
> Ok. I'm fine with putting it into the stack. I'll take Michael by the
> word though that he'll do dynamically registered tx handlers later ;)

So just to be clear, this patch does not need any tweaking anymore right?
Latest patch series for rt2x00 accidently  had software sequence handling
removed out of rt2400pci and rt2500pci so it is actually broken and at the moment.
So I need to either restore it back into the rt2x00 drivers or the mac80211 stack needs
to get the support so rt2x00 can use it. :)

Ivo
