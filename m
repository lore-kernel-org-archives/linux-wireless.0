Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:54881 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZG2QKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 12:10:14 -0400
Message-ID: <4A707463.1000508@mandriva.org>
Date: Wed, 29 Jul 2009 19:10:11 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at net/mac80211/agg-tx.c:145
References: <4A6F264E.70501@mandriva.org> <1248798501.13742.1.camel@johannes.local>
In-Reply-To: <1248798501.13742.1.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg skrev:
> On Tue, 2009-07-28 at 19:24 +0300, Thomas Backlund wrote:
>> Hi,
>>
>> Is this known?
> 
> I think so. The problem is that on a hw restart the driver clears
> aggregation but mac80211 thinks the session is still up, I think.
> 


ok, so is there any fixes to test...

--
Thomas
