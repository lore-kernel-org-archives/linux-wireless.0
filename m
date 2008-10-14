Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39002 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYJNHBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 03:01:10 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 14:59:41 +0800
Message-Id: <1223967581.2570.144.camel@debian.sh.intel.com> (sfid-20081014_090115_734311_CE93576A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-10 at 09:49 -0700, Luis R. Rodriguez wrote:
> The real correct behavior here, as the comment also
> indicates, is we should be doing an intersection between the two
> regulatory domains and I sent a RFC on a some initial code I had to
> support such intersection. Until that is not merged we just respect
> first regulatory request.

Why should the intersection be the correct behavior? In my previous
example, the intersection of a BG card and an ABG card is the BG bands.
Why shouldn't the ABG card have the A band support?

Thanks,
-yi

