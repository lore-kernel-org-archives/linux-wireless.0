Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54146 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564Ab1HIMtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 08:49:15 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so1482267ewy.33
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 05:49:14 -0700 (PDT)
Subject: Re: [PATCH 04/40] wl12xx: temporarily disable 11n and advanced ap
 functions
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-5-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-5-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 15:49:11 +0300
Message-ID: <1312894151.2407.177.camel@cumari> (sfid-20110809_144919_070416_C46E613C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> In order to keep to driver compiling during the patchset,
> while avoiding one-huge-patch, temporarily disable 11n
> and some advanced ap functions.
> 
> These changes will be reverted later in the patchset, as
> part of the patches for 11n and advanced ap functions
> support for the new fw.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

As discussed on IRC, please remove the #if 0's for the BA part as we
agreed they're not needed and recheck if all the other cases are really
necessary (and please explain why! :)


-- 
Cheers,
Luca.

