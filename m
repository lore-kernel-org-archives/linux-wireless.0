Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1879 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab2ALUMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 15:12:01 -0500
Message-ID: <4F0F3E77.1040208@broadcom.com> (sfid-20120112_211210_230373_364CBE71)
Date: Thu, 12 Jan 2012 21:11:35 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Francis Moreau" <francis.moro@gmail.com>
cc: "Alwin Beukers" <alwin@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac broken with 3.2
References: <CAC9WiBj8VkYe7ku7rc-e_+d7yNEAtEiozs8tnR_A1T1H3XjiSA@mail.gmail.com>
In-Reply-To: <CAC9WiBj8VkYe7ku7rc-e_+d7yNEAtEiozs8tnR_A1T1H3XjiSA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2012 08:32 PM, Francis Moreau wrote:
> Hello,
> 
> I'm facing a new issue after upgrading from 3.1 to 3.2.
> 
> It happens when switching on/off my wireless card (BCM4313 [14e4:4727]).
> 
> Here's the oops I'm getting:
> 
> [36370.370768] WARNING: at net/mac80211/rx.c:2979
> ieee80211_rx+0x91b/0x9e0 [mac80211]()

What kernel tree are you using?

Gr. AvS


