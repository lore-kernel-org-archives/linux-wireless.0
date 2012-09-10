Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36751 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab2IJPnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 11:43:42 -0400
Message-ID: <1347291849.4272.27.camel@jlt4.sipsolutions.net> (sfid-20120910_174345_914865_EF49CCC8)
Subject: Re: kernel 3.5.2/amd64: iwlwifi 0000:03:00.0: failed to allocate
 pci memory
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Marc MERLIN <marc@merlins.org>, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
Date: Mon, 10 Sep 2012 17:44:09 +0200
In-Reply-To: <504E037B.9030801@lwfinger.net> (sfid-20120910_171305_381831_E8B3328A)
References: <20120908161038.GF3347@merlins.org>
	  <1347122927.1234.849.camel@edumazet-glaptop>
	  <20120904003014.GB6287@merlins.org> <20120908170128.GK3347@merlins.org>
	  (sfid-20120908_190214_109241_625AC686) <1347130641.11167.0.camel@jlt4.sipsolutions.net>
	  (sfid-20120908_205654_374994_2998A2BE) <1347272641.4272.1.camel@jlt4.sipsolutions.net>
	 <504E037B.9030801@lwfinger.net> (sfid-20120910_171305_381831_E8B3328A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-10 at 10:12 -0500, Larry Finger wrote:

> > http://p.sipsolutions.net/11ea33b376a5bac5.txt
> 
> That patch looks like a good way to solve the problem; however, some 
> architectures need an explicit "#include <linux/vmalloc.h>" somewhere in the 
> headers, even though x86 does not, and I did not see it in the patch. I didn't 
> do a lot of checking, but grep did not find one in the existing code.

Thanks for that, I added the include.

johannes

