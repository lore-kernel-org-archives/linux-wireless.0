Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:49994 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbaBUOvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 09:51:14 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so2379185lan.38
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 06:51:12 -0800 (PST)
Message-ID: <530767DE.4070501@27m.se> (sfid-20140221_155117_617312_1F4C9531)
Date: Fri, 21 Feb 2014 15:51:10 +0100
From: Jones Desougi <jones.desougi@27m.se>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Luciano Coelho <luca@coelho.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: docbook: fix small formatting error
References: <1392907534-14470-1-git-send-email-luca@coelho.fi> <1392971037.4346.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1392971037.4346.16.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2014 09:23 AM, Johannes Berg wrote:
> On Thu, 2014-02-20 at 16:45 +0200, Luciano Coelho wrote:
>> From: Luciano Coelho <luciano.coelho@intel.com>
>>
>> docbook (or one of its friends) gets confused with semi-colons in the
>> argument descriptions, causing it to think that the semi-colon is
>> marking a new section in the description of addr_mask in wiphy struct.
>>
>> Prevent this by using hyphens instead of semi-colons in the mask
>> example.
> 
> Applied, thanks.

Well, the changelog says that semi-colons are a problem while the patch
actually replaces colons. Fishy. :)

   /Jones

