Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35703 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753016AbXJZPRy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 11:17:54 -0400
Message-ID: <4722051E.8080302@sgi.com> (sfid-20071026_161758_974431_A80302FC)
Date: Fri, 26 Oct 2007 17:17:50 +0200
From: Jes Sorensen <jes@sgi.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: iwl4965 detection problem
References: <47209C0C.5010505@sgi.com> <1193319925.5542.8.camel@localhost.localdomain> <4720A509.2070708@sgi.com> <1193333545.2111.8.camel@localhost.localdomain> <47219FE6.70900@sgi.com> <20071026123044.GB23415@tuxdriver.com> <4721E17E.2020908@sgi.com> <4721F55F.1030303@sgi.com>
In-Reply-To: <4721F55F.1030303@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen wrote:
> I haven't had a chance to build the driver with this change, ie. it's
> untested, but I have a suspicion that this patch might do the job.

So, tested a kernel with this patch applied, and voila! My wireless
now works on first boot!

Should I post it to linux-kernel or Andrew or will someone on this list
collect it and push it upstream?

Cheers,
Jes

