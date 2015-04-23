Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbbDWJPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 05:15:03 -0400
Date: Thu, 23 Apr 2015 11:15:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi getting stuck with current Linus' tree (646da63172)
In-Reply-To: <1429780366.11859.1.camel@intel.com>
Message-ID: <alpine.LNX.2.00.1504231114290.3695@pobox.suse.cz> (sfid-20150423_111523_870637_6D4201DA)
References: <alpine.LNX.2.00.1504222235340.3695@pobox.suse.cz>  <1429764440.4084.5.camel@intel.com>  <alpine.LNX.2.00.1504231011500.3695@pobox.suse.cz> <1429780366.11859.1.camel@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 23 Apr 2015, Grumbach, Emmanuel wrote:

> > I will try it, but I expect the result to be bogus because of this, 
> > unfortunately.
> 
> I can understand. A few users reported that this bug occurred more
> reliably when moving their system, although it seems very weird to me.

My "feeling" was that it sometimes was related to start of audio playback, 
but not 100% relieble either.

> > > First question is: Are you sure that 4.0-rc6 was good?
> > 
> > Pretty much, yes. I've been running it for quite some time on this 
> > machine without any issues. But after updating to current HEAD two days 
> > ago, the issue triggered like 6 or 7 times already.
> 
> Ok - I will try to look at the PCI commits there although I am not sure 
> I'll be able to make much sense of them...

Thanks,

-- 
Jiri Kosina
SUSE Labs
