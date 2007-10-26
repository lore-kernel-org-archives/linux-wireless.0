Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3598 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbXJZOmB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 10:42:01 -0400
Date: Fri, 26 Oct 2007 10:41:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jes Sorensen <jes@sgi.com>
Cc: Dan Williams <dcbw@redhat.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: iwl4965 detection problem
Message-ID: <20071026144137.GD23415@tuxdriver.com> (sfid-20071026_154212_791431_0C7DF39B)
References: <47209C0C.5010505@sgi.com> <1193319925.5542.8.camel@localhost.localdomain> <4720A509.2070708@sgi.com> <1193333545.2111.8.camel@localhost.localdomain> <47219FE6.70900@sgi.com> <20071026123044.GB23415@tuxdriver.com> <4721E17E.2020908@sgi.com> <4721F55F.1030303@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4721F55F.1030303@sgi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2007 at 04:10:39PM +0200, Jes Sorensen wrote:

> Disable interrupts in the iwl4965 before calling request_irq() for
> the case that the previous OS or the BIOS left a pending interrupt in
> the chip. This behavior has been observed on some laptops such as T61
> Thinkpads and Toshiba Portege R500

Any reason this would not be appropriate for iwl3945 as well?

John
-- 
John W. Linville
linville@tuxdriver.com
