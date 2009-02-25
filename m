Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36677 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbZBYSfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 13:35:24 -0500
Message-ID: <49A58F63.9090309@lwfinger.net> (sfid-20090225_193527_706502_5C3DE0B7)
Date: Wed, 25 Feb 2009 12:35:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Latest test  with open-source firmware
References: <49A56B1F.80702@lwfinger.net> <200902251846.31531.mb@bu3sch.de>
In-Reply-To: <200902251846.31531.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 25 February 2009 17:00:31 Larry Finger wrote:
>>
>> The 00:26:24 event was the interface going offline. That happens with
>> proprietary firmware, thus I think that problem is with the driver, rather than
>> the firmware.
> 
> Are you sure it's a problem at all and not just simply failure to deliver
> certain important management frames due to _extreme_ queue pressure?
> Especially the tight RX queue will have effects like dropped frames.

No, I don't know. If I get the same problem with a queue depth of 64, is there
any problem with increasing it to 128 for testing?

Larry
