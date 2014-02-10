Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:50085 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaBJMyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 07:54:08 -0500
Date: Mon, 10 Feb 2014 13:54:04 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: wlwifi - Microcode SW error detected.
Message-ID: <20140210125404.GD7117@dhcp22.suse.cz> (sfid-20140210_135427_036107_ACF64E46)
References: <20140207151942.GE5121@dhcp22.suse.cz>
 <0BA3FCBA62E2DC44AF3030971E174FB303D640E9@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D640E9@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 09-02-14 06:46:20, Grumbach, Emmanuel wrote:
[...]
> Is this a regression?

No idea. I haven't tried to reproduce it.

> To me, it looks like a pure firmware issue.

The message points at FW but I have no idea what it actually tries to
tell, except that something went really wrong.
-- 
Michal Hocko
SUSE Labs
