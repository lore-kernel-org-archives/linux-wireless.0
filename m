Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1312 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab2HFTp4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:45:56 -0400
Message-ID: <50201EDD.30408@broadcom.com> (sfid-20120806_214559_960660_C84D45C7)
Date: Mon, 6 Aug 2012 21:45:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Vladimir Zapolskiy" <vz@mleia.com>
cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcm80211: smac: set interface down on reset
References: <1344115747-25627-1-git-send-email-vz@mleia.com>
 <50201D62.2020701@mleia.com>
In-Reply-To: <50201D62.2020701@mleia.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2012 09:39 PM, Vladimir Zapolskiy wrote:
> Hi Arend,
> 
> what do you think about the proposed change? For me the problem is
> quite severe, for the last several months I had to patch the kernel
> to have functional BCM43225 on my laptop, hopefully the fix should go to
> the
> stable branches as well.
> 

I have forwarded it to my colleagues. I may want to revise the fix  a
little and have it applied to stable as well. I was not aware that this
scenario occurs frequently. Thanks for addressing your issue so
proactively ;-)

Gr. AvS

