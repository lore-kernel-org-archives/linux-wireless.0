Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49548 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760009Ab3EXKLH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 06:11:07 -0400
Received: from mailout-de.gmx.net ([10.1.76.12]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LrY9r-1UTbeu0Mpx-013MXD for
 <linux-wireless@vger.kernel.org>; Fri, 24 May 2013 12:11:05 +0200
Message-ID: <519F3CB7.6010006@rempel-privat.de> (sfid-20130524_121111_045910_52AB72BB)
Date: Fri, 24 May 2013 12:11:03 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mac80211: add STBC flag for radiotap
References: <1369250674.8207.26.camel@jlt4.sipsolutions.net>  <1369389945-805-1-git-send-email-linux@rempel-privat.de>  (sfid-20130524_120552_318974_4993675A) <1369390088.8290.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1369390088.8290.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 24.05.2013 12:08, schrieb Johannes Berg:
> On Fri, 2013-05-24 at 12:05 +0200, Oleksij Rempel wrote:
>> Some chips can tell us if received frame was
>> encoded with STBC or not. To make this information available
>> in user space we can use updated radiotap specification:
>> http://www.radiotap.org/defined-fields/MCS
>>
>> This patch will set number of STBC encoded spatial streams (Nss).
>> The HAVE_STBC flag should be provided by driver.
>
> Applied, thanks.
>

thank you.

-- 
Regards,
Oleksij
