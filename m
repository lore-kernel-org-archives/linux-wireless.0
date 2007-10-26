Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35054 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759088AbXJZOne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 10:43:34 -0400
Message-ID: <4721FD12.4060800@sgi.com> (sfid-20071026_154401_173289_28C07F78)
Date: Fri, 26 Oct 2007 16:43:30 +0200
From: Jes Sorensen <jes@sgi.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: iwl4965 detection problem
References: <47209C0C.5010505@sgi.com> <1193319925.5542.8.camel@localhost.localdomain> <4720A509.2070708@sgi.com> <1193333545.2111.8.camel@localhost.localdomain> <47219FE6.70900@sgi.com> <20071026123044.GB23415@tuxdriver.com> <4721E17E.2020908@sgi.com> <4721F55F.1030303@sgi.com> <20071026144137.GD23415@tuxdriver.com>
In-Reply-To: <20071026144137.GD23415@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, Oct 26, 2007 at 04:10:39PM +0200, Jes Sorensen wrote:
> 
>> Disable interrupts in the iwl4965 before calling request_irq() for
>> the case that the previous OS or the BIOS left a pending interrupt in
>> the chip. This behavior has been observed on some laptops such as T61
>> Thinkpads and Toshiba Portege R500
> 
> Any reason this would not be appropriate for iwl3945 as well?

I cannot say for sure since I don't have one here, but a brief look at
the code indicates that it might.

I'm trying to build a kernel here with the patch now.

Cheers,
Jes
