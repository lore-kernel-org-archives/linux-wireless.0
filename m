Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbbJHVGL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 17:06:11 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Jakub Sitnicki <jsitnicki@gmail.com>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<87d1wp49ds.fsf@frog.home> <wrfjio6h18jq.fsf@redhat.com>
	<20151008223355.248614c9@mir>
Date: Thu, 08 Oct 2015 17:06:10 -0400
In-Reply-To: <20151008223355.248614c9@mir> (Stefan Lippers-Hollmann's message
	of "Thu, 8 Oct 2015 22:33:55 +0200")
Message-ID: <wrfj1td5135p.fsf@redhat.com> (sfid-20151008_230614_772088_FBBEB5B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Lippers-Hollmann <s.l-h@gmx.de> writes:
> Hi
>
> On 2015-10-08, Jes Sorensen wrote:
>> I have an 8188EU dongle in my wifi dongle pouch, together with several
>> other yet to be supported ones :) I am currently trying to get the
>> 8723BU and 8192EU working, but I haven't had time to work much on the
>> 8188EU yet.
> [...]
>
> I was wondering about a pretty similar question, do you see this driver 
> as being potentially compatible with rtl8192su[1] or rtl8192du[2] devices
> or are these too different[3]?

Same answer :) My pouch also contains an 8192SU and an 8192DU dongle,
albeit I haven't looked much at that code at all so far.

Cheers,
Jes
