Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61367 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457AbXHHMEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 08:04:08 -0400
Message-ID: <46B9B130.8090006@lwfinger.net>
Date: Wed, 08 Aug 2007 07:04:00 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Pavel Roskin <proski@gnu.org>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix handling of failure to create debugfs directory
References: <20070808051710.3902.43211.stgit@dv.roinet.com> <200708081104.56295.mb@bu3sch.de>
In-Reply-To: <200708081104.56295.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 08 August 2007 07:17:10 Pavel Roskin wrote:
>> This can happen if CONFIG_BCM43XX_MAC80211_DEBUG is enabled, but
>> CONFIG_DEBUG_FS is not.
>>
>> Signed-off-by: Pavel Roskin <proski@gnu.org>
>> ---
> 
> Thanks, queued.
> Larry, this might also apply to bcm4301.

Yes it will. Thanks,

Larry

