Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36423 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbcCQNSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:18:14 -0400
Date: Thu, 17 Mar 2016 06:18:11 -0700
From: "tj@kernel.org" <tj@kernel.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Eva Rachel Retuya <eraretuya@gmail.com>,
	"outreachy-kernel@googlegroups.com"
	<outreachy-kernel@googlegroups.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: dvm: convert create_singlethread_workqueue() to
 alloc_workqueue()
Message-ID: <20160317131811.GO21104@mtj.duckdns.org> (sfid-20160317_141836_827528_59399079)
References: <1458218246-18807-1-git-send-email-eraretuya@gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA7C435@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA7C435@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Thu, Mar 17, 2016 at 12:43:35PM +0000, Grumbach, Emmanuel wrote:
> > 
> > Use alloc_workqueue() to allocate the workqueue instead of
> > create_singlethread_workqueue() since the latter is deprecated and is
> > scheduled
> > for removal.
> 
> I can't see any indication of that in the code of workqueue.
> Can you share details about that?

create*_workqueue()'s have been deprecated and replaced by
alloc*_workqueue()'s for some years now.  I probably should note that
in the header file.

Thanks.

-- 
tejun
