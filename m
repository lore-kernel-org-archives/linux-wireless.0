Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56737 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1BWPQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 10:16:14 -0500
Received: by vws12 with SMTP id 12so3141105vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 07:16:13 -0800 (PST)
Message-ID: <4D652498.4090507@lwfinger.net>
Date: Wed, 23 Feb 2011 09:15:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Sebastien Jan <s-jan@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] WLAN: fix the path to the wl12xx firmwares
References: <1298467516-9092-1-git-send-email-s-jan@ti.com>	 <1298471599.2104.44.camel@pimenta>  <20110223144134.GA2729@tuxdriver.com> <1298472865.2104.48.camel@pimenta>
In-Reply-To: <1298472865.2104.48.camel@pimenta>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2011 08:54 AM, Luciano Coelho wrote:
> On Wed, 2011-02-23 at 09:41 -0500, John W. Linville wrote:
>>
>> I think there are a number of other drivers with embedded pathnames.
> 
> Indeed.  And, as discussed with Johannes on IRC, the / will be just one
> more character in the FW name, regardless of whether it means a
> subdirectory or not.  It's just part of the FW name string.
> 
> When I apply the patch, I just need to brace for the loads of people
> complaining that the FW cannot be found anymore and explain the issue a
> hundred times. ;)

You could keep the old path as a fallback for a couple of cycles and log a
message warning users to move their firmware.

Larry
