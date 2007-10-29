Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36856 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbXJ2BWA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 21:22:00 -0400
Subject: Re: iwl4965 detection problem
From: Zhu Yi <yi.zhu@intel.com>
To: Jes Sorensen <jes@sgi.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <4721F55F.1030303@sgi.com>
References: <47209C0C.5010505@sgi.com>
	 <1193319925.5542.8.camel@localhost.localdomain> <4720A509.2070708@sgi.com>
	 <1193333545.2111.8.camel@localhost.localdomain> <47219FE6.70900@sgi.com>
	 <20071026123044.GB23415@tuxdriver.com> <4721E17E.2020908@sgi.com>
	 <4721F55F.1030303@sgi.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 09:14:07 +0800
Message-Id: <1193620447.3069.484.camel@debian.sh.intel.com> (sfid-20071029_012204_748527_2395FBB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2007-10-26 at 16:10 +0200, Jes Sorensen wrote:
> Disable interrupts in the iwl4965 before calling request_irq() for
> the case that the previous OS or the BIOS left a pending interrupt in
> the chip. This behavior has been observed on some laptops such as T61
> Thinkpads and Toshiba Portege R500
> 
> Signed-off-by: Jes Sorensen <jes@sgi.com>

ACK.

Good catch. And it explains why it doesn't work _sometimes_ (although I
never have the problem on my box).

Thanks,
-yi
