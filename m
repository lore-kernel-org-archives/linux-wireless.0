Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:52665 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZELUyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 16:54:09 -0400
Received: by fk-out-0910.google.com with SMTP id 18so110597fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 13:54:09 -0700 (PDT)
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241421545.6866.2.camel@johannes.local>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
	 <1241421545.6866.2.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 12 May 2009 23:54:03 +0300
Message-Id: <1242161643.26484.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-05-04 at 09:19 +0200, Johannes Berg wrote:
> On Mon, 2009-05-04 at 00:46 +0300, Maxim Levitsky wrote:
> > Yes, sure
> > For record I use iwlwifi.git commit
> > 5a94b6d38100b7056a5a347e5c51359d924d305d
> 
> Ok.
> 
> > Logs attached.
> > This bug can be reliably reproduced, happens every 5~10 times when I
> > turn rfkill on/off, but today again this happened after resume from
> > disk.
> 
> Ah, rfkill. Hmm, unfortunately I don't have a system with rfkill. I
> looked at ieee80211_scan_work but can't see how it would abort the
> scan... Could you put some debugging into that function? Especially
> printing out the state when it enters, whether it calls

Hi,

I can't seem to reproduce that ether.
Maybe this got fixed (I have seen few suspicios commits in
wireless-testing... althought I think this is a wishfull thinking)

Anyway, I I have put printks in ieee80211_scan_work.


Best regards,
	Maxim Levitsky

