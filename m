Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38239 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab2K3LzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 06:55:06 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so469064ieb.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2012 03:55:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121130103549.GA26790@redhat.com>
References: <CABPxzYL=MBQ3uZR=EmcNAa-9iELPKRWtwZNBnxpFdk7z5XpPKw@mail.gmail.com>
 <20121130103549.GA26790@redhat.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 30 Nov 2012 17:24:44 +0530
Message-ID: <CABPxzYKWvXkQCWtRxjjPRvgk5DceFvEYM-kSqcdqUQcQ34vxuQ@mail.gmail.com> (sfid-20121130_125512_091653_F0DBE3E4)
Subject: Re: [PATCH] iwl4965:Fixing Broken Monitor Mode Functionality
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: johannes@sipsolutions.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	maheshp@posedge.com, chaitanyatk@posedge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

But that patch is not part of the mac80211-next branch.
Hence missed it. So what git tree is that checked in.

Thanks.

On Fri, Nov 30, 2012 at 4:05 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Fri, Nov 30, 2012 at 02:59:12PM +0530, Krishna Chaitanya wrote:
>> From the patch  "90b9e446fbb64630c72cab48c007d7081aec2533: mac80211:
>> support radiotap vendor namespace RX data"
>> the monitor mode functionality in iwl4965 stopped working, because of
>> below issues
>>
>> 1) The driver doesnt fill the newly added fields in the ieee80211_rx_status
>> and also doesn't do a memset leading to junk values.
>
> Already fixed by Johannes:
> https://patchwork.kernel.org/patch/1788371/
>
> Stanislaw
>
