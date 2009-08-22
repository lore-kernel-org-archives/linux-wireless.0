Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:42585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933248AbZHVTAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 15:00:09 -0400
Received: by fg-out-1718.google.com with SMTP id e12so327590fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 12:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250967366.23605.23.camel@johannes.local>
References: <4A903BEB.4030606@flidais.net> <1250967366.23605.23.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 22 Aug 2009 20:59:50 +0200
Message-ID: <69e28c910908221159r78f6dfffsab59fe4c4c4e5906@mail.gmail.com>
Subject: Re: Broadcom BCM43XG Master mode?
To: Nathan Kennedy <nathan@flidais.net>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 22, 2009 at 8:56 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Sat, 2009-08-22 at 11:41 -0700, Nathan Kennedy wrote:
>> I recently purchased a Linksys WMP300N that has teh BCM43XG chipset.
>> The only driver that I've gotten to work well with it is the wl driver
>> from Broadcom, however when I try to set the wireless mode to master I
>> get an error that the operation is not permitted.  Is there a different
>> way to get this card into master mode?
>
> If you're using wl, then we don't know, and you have to ask Broadcom.
>
> If you're using b43, you start hostapd.
>
> johannes
>

WMP300N is an N-PHY, not supported by b43 (LP-PHY is being done right
now, N-PHY is probably the next). AFAIK wl (the hybrid driver) only
supports STA mode, there is no AP-ready x86 driver (Broadcom only
makes AP drivers for the MIPS platform).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
