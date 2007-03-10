Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:27352 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXCJTB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2007 14:01:57 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1725787uga
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2007 11:01:55 -0800 (PST)
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Sat, 10 Mar 2007 20:01:40 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com> <200703101538.55267.IvDoorn@gmail.com> <200703101251.07345.flamingice@sourmilk.net>
In-Reply-To: <200703101251.07345.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703102001.41004.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 March 2007 18:51, Michael Wu wrote:
> On Saturday 10 March 2007 09:38, Ivo van Doorn wrote:
> > So just to be clear, this patch does not need any tweaking anymore right?
> Just stick the counter in sdata if you haven't done so already. Should be fine 
> once that's done.

Ah ok. I had it in ieee80211_sta_bss.
I'll create a new patch with the sequence number in the right location.

Thanks.

Ivo
