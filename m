Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:42527 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919AbYGDW47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 18:56:59 -0400
Message-ID: <486EAAB6.2070000@linux.intel.com> (sfid-20080705_005704_078175_395EFA0F)
Date: Fri, 04 Jul 2008 15:56:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Oops/Warning report of the week of July 4th 2008
References: <486EA0D6.2040504@linux.intel.com> <200807050038.49712.IvDoorn@gmail.com>
In-Reply-To: <200807050038.49712.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> Hi,
> 
>> Rank 12: flush_workqueue (oops)
>> 	Reported 39 times
>> 	Bug in the rt25xx driver passing NULL to the flush_workqueue() function
>> 	This oops was last seen in version 2.6.25.9, and first seen in 2.6.25.9.
>> 	More info: http://www.kerneloops.org/searchweek.php?search=flush_workqueue
> 
> Hmm, interesting I hadn't received such reports yet..

it only very recently showed up on kerneloops.org (the .9 release from Fedora is only a 2 or 3 days old).
In addition, while I monitor what's going on, oops patterns need to cross roughly a 25/week pattern for
me to notice them as standing out...

If I see other patterns come up I'll send out email again ;-)
