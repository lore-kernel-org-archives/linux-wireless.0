Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:43258 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757644AbXFLUfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 16:35:12 -0400
Message-ID: <466F037C.9080403@lwfinger.net>
Date: Tue, 12 Jun 2007 15:35:08 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net> <200706071819.45603.flamingice@sourmilk.net>
In-Reply-To: <200706071819.45603.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> 
> One last thing - max_ratectrl_rateidx should be set to -1 to indicate no 
> maximum. Not doing this will cause problems when switching from one hw mode 
> to another with a different number of rates.

I don't understand this last part. If we use the upper-limit form of the rate command, isn't that 
indicated to the rate-setting routine by having max_ratectrl_index set to the upper limit, and 
force_unicast_rateidx set to -1? If max_ratectrl_rateidx must always be -1, why does it exist as a 
parameter?

Larry
