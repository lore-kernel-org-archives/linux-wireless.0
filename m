Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:58282 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751167AbaAWUVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 15:21:50 -0500
Date: Thu, 23 Jan 2014 22:21:43 +0200
From: Petko Manolov <petkan@nucleusys.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi crash with 3.13
Message-ID: <20140123202142.GC4064@localhost> (sfid-20140123_212154_206616_4F75B031)
References: <20140123091659.GE9077@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com>
 <20140123123125.GA3424@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
 <20140123200045.GA4064@localhost>
 <52E17698.9070607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52E17698.9070607@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-01-23 22:07:52, Emmanuel Grumbach wrote:
> 
> Unfortunately, I can't see the loading of iwlwifi.

It overflowed.  That's what happen when debug != 0 ... :)

> Doesn't matter any more - I found the issue.

Ah, good.  Cheers.


		Petko
