Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61115 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbXE0Be3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 21:34:29 -0400
Message-ID: <4658E023.3020800@lwfinger.net>
Date: Sat, 26 May 2007 20:34:27 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: mabbas@linux.intel.com, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/T] mac80211: Implementation of SIOCSIWRATE
References: <46585cd1.xDmttJDPjdAQW3Wz%Larry.Finger@lwfinger.net> <200705261631.05971.flamingice@sourmilk.net>
In-Reply-To: <200705261631.05971.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:

> No. Use force_unicast_rateidx and max_ratectrl_rateidx.

I did a quick check for a description of the hostap (prism2) ioctl's, but didn't find them, and I'm 
not sure how these parameters are used. Could you suggest a reference?

Thanks,

Larry
