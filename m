Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:34390 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbaBGVlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 16:41:00 -0500
Date: Fri, 7 Feb 2014 23:40:54 +0200
From: Petko Manolov <petkan@nucleusys.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi crash with 3.13
Message-ID: <20140207214054.GB7167@localhost> (sfid-20140207_224119_968893_A9B877BA)
References: <20140123091659.GE9077@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com>
 <20140123123125.GA3424@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
 <20140123200045.GA4064@localhost>
 <52E17698.9070607@gmail.com>
 <20140123202142.GC4064@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140123202142.GC4064@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-01-23 22:21:42, Petko Manolov wrote:
> On 14-01-23 22:07:52, Emmanuel Grumbach wrote:
> > 
> > Unfortunately, I can't see the loading of iwlwifi.
> 
> It overflowed.  That's what happen when debug != 0 ... :)
> 
> > Doesn't matter any more - I found the issue.
> 
> Ah, good.  Cheers.

Hello Emmanuel, did you manage to fix the problem?  I can see iwlwifi related patch went into 3.13.2, but in case it was supposed to fix the 
issue - it didn't do that for me.  As usual, can i help with anything?


cheers,
Petko
