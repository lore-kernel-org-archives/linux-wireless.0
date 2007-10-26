Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35105 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905AbXJZMpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 08:45:53 -0400
Message-ID: <4721E17E.2020908@sgi.com> (sfid-20071026_134558_115201_F9810A17)
Date: Fri, 26 Oct 2007 14:45:50 +0200
From: Jes Sorensen <jes@sgi.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: iwl4965 detection problem
References: <47209C0C.5010505@sgi.com> <1193319925.5542.8.camel@localhost.localdomain> <4720A509.2070708@sgi.com> <1193333545.2111.8.camel@localhost.localdomain> <47219FE6.70900@sgi.com> <20071026123044.GB23415@tuxdriver.com>
In-Reply-To: <20071026123044.GB23415@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> I've been seeing this behaviour _sometimes_ as well.  (/me hates _sometimes_)
> 
> Fresh off the presses, an F8-based build w/ the latest round of
> iwl4965 updates from Zhu Yi and friends:
> 
> 	http://koji.fedoraproject.org/koji/taskinfo?taskID=215212
> 
> I haven't had a chance to test it yet myself (built it overnight),
> so YMMV.  Still, there is a lot of iwl4965 churn in there so it is
> probably worth some testing.  (Newer than wireless-2.6!)

Hi John,

Thanks for the suggestion, just tried it out - seems to behave the
same way as the old kernel :-(

At least it's consistent here as opposed to sometimes.

One thing I noted is that rmmod often takes a few seconds, no idea
if it has any value?

Cheers,
Jes
