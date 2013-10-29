Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63857 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3J2UQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 16:16:38 -0400
Message-ID: <527017A3.9020109@lwfinger.net> (sfid-20131029_211642_591271_9CF7A4F4)
Date: Tue, 29 Oct 2013 15:16:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
	Ben Hutchings <bhutchings@solarflare.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH NEXT] rtlwifi: Fix endian error in extracting packet type
References: <1383002903-8746-1-git-send-email-Larry.Finger@lwfinger.net>	<1383005246.3779.61.camel@bwh-desktop.uk.level5networks.com> <87y55cf8yq.fsf@nemi.mork.no>
In-Reply-To: <87y55cf8yq.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2013 09:27 AM, Bjørn Mork wrote:
>
> It's not validating the upper 8 bits of the port numbers either, so it
> will hit random UDP traffic in addition to DHCP.
>
> But it was good to see this function now. I was wondering how to support
> some buggy 3G modem firmware without ugly hacks. Seems there will always
> be worse hacks in drivers/net, no matter what I do :-)

I'm happy that Realtek and I could make your day. The next version is checking 
the full 16-bit port numbers.

Thanks,

Larry


