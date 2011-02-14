Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2161 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1BNUk4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 15:40:56 -0500
Message-ID: <4D59934D.2020600@broadcom.com>
Date: Mon, 14 Feb 2011 21:40:45 +0100
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>,
	"s@fomichev.me" <s@fomichev.me>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: remove multiple calls to wl_release_fw
References: <20110212150033.GA1941@sdf-MacBook>
 <4D598993.4020900@broadcom.com> <20110214202249.GK4384@bicker>
In-Reply-To: <20110214202249.GK4384@bicker>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Dan and Stanislav,

I already had a patch in the making that is a superset of Stanislav's 
patch. It fixes the leak issue. I agreed with Stanislav's patch since, I 
made the same (but: more) changes. Stanislav, can we agree that we wait 
for my patch (I plan on delivering this tomorrow) ?

Thanks, Roland.

On 02/14/2011 09:22 PM, Dan Carpenter wrote:
>> On 02/12/2011 04:00 PM, Stanislav Fomichev wrote:
>>> This causes an oops when the bcm43xx_hdr-0.fw binary is not found.
>>>
>
> This patch isn't right.  It fixes the oops but it introduces some leaks.
> (We still need to release firmware that was allocated successfully).
>
> regards,
> dan carpenter
>


