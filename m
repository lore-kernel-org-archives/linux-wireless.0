Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52776 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab1HDUIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 16:08:02 -0400
Received: by yia27 with SMTP id 27so1305694yia.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Aug 2011 13:08:02 -0700 (PDT)
Message-ID: <4E3AFC1F.6040708@lwfinger.net> (sfid-20110804_220807_470114_57C0665D)
Date: Thu, 04 Aug 2011 15:07:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Anthony Bourguignon <contact+kernel@toniob.net>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: rt2x00: Add rt2870 device id
References: <1312487142.4832.8.camel@moss>
In-Reply-To: <1312487142.4832.8.camel@moss>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/04/2011 02:45 PM, Anthony Bourguignon wrote:
> Hello,
>
> Dvico ships WiFi usb keys with some of their tvix hardware. The vendor
> id is related to dvico and not known from the rt2800usb driver. The
> chipset is found to be a rt2870. You'll find enclosed a patch to handle
> theses usb keys. I've tested it on a vanilla 3.0 kernel and the key is
> recognize and working perfectly.

Please read and follow the instructions in Documentation/SubmittingPatches. 
There are several things wrong here including no "Signed-off-by" line and the 
patch should be in-line, not as an attachment.

For wireless devices, the patch should be sent to John Linville 
<linville@tuxdriver.com> with the mailing lists as Cc.

Thanks for posting this info and good luck with the patch preparation.

Larry
