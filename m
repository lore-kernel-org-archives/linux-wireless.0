Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:39011 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2DTFTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 01:19:01 -0400
Message-ID: <4F90F1C3.8020604@hartkopp.net> (sfid-20120420_071913_574685_E8DED05B)
Date: Fri, 20 Apr 2012 07:18:59 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
CC: David Miller <davem@davemloft.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Spinadel, David" <david.spinadel@intel.com>
Subject: Re: net-next iwlwifi breaks compile - was Re: pull request: wireless-next
 2012-04-18
References: <20120418.153653.2130740499995307564.davem@davemloft.net> <4F8F9977.9040703@hartkopp.net> <4595B4D22AB93C4FABBA84AAD5AA37FD1258AA@ORSMSX103.amr.corp.intel.com> <20120419.154954.1322943404183128381.davem@davemloft.net> <4595B4D22AB93C4FABBA84AAD5AA37FD1259E6@ORSMSX103.amr.corp.intel.com>
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD1259E6@ORSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks guys!

I just pulled net-next and it's compiling properly now.

Regards,
Oliver

On 19.04.2012 23:07, Venkataraman, Meenakshi wrote:

> Hi David,
> 
>>> It was fixed internally in a subsequent patch, but that patch has not
>>> made it into net-next. I don't see it in the public iwlwifi repository
>>> either. We'll add the fix to the repository so you can pick it up.
>>
>> That's not how this works.
>>
>> You should submit a patch to fix the build directly to me, immediately, so that I
>> can push it directly into net-next as fast as possible.
> 
> [MV]  Okay -- this is good to know. Essentially -- if any upstream tree breaks due to our work, then a fix should be directly submitted ASAP to the maintainer of that tree.
> 
> I see that Wey-Yi has already sent you the fix, so nothing left for me to do on this one.
> 
> Thanks,
> Meenakshi


