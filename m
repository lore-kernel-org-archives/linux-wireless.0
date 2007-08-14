Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:59053 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934706AbXHNWSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 18:18:38 -0400
Message-ID: <46C22A3B.1090802@lwfinger.net>
Date: Tue, 14 Aug 2007 17:18:35 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [patch 0/7] SSB: New patch series for merge
References: <200708141900.31273.mb@bu3sch.de> <46C1E790.3020807@lwfinger.net> <200708141938.33952.mb@bu3sch.de>
In-Reply-To: <200708141938.33952.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 14 August 2007 19:34:08 Larry Finger wrote:
>> Michael Buesch wrote:
>>> Hi John,
>>>
>>> This patch series catches SSB up to my
>>> current wireless-development patchset.
>>>
>>> Please merge this into wireless-dev ssb branch.
>> I had a problem with #7. My copy of John's tree still has EXPERIMENTAL for ssb. Yours does not.
> 
> Are you sure you have latest wireless-dev? It has
> been rebased again.
> 

Indeed, that was the problem. Once I got John's email and learned how to handle the new rebase, you 
patch applied just fine.

Larry


