Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61201 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2J3Pba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 11:31:30 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so556620iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2012 08:31:29 -0700 (PDT)
Message-ID: <508FF2C2.4000900@lwfinger.net> (sfid-20121030_163134_042389_191F0D73)
Date: Tue, 30 Oct 2012 10:31:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Albert Pool <albertpool@solcon.nl>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: rtl8192cu: ISY IWL 2000 USB ID added
References: <508FCEA9.6000504@solcon.nl>
In-Reply-To: <508FCEA9.6000504@solcon.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2012 07:57 AM, Albert Pool wrote:
> I can't get the device to connect to my wifi, but it at least detects networks
> with this patch.
> Probably a clone of Belkin F7D1102 050d:1102. Its FCC ID is the same.

I prefer to see full operation before we add a new ID. I agree that having the 
same FCC ID makes it seem that it is the same as the 050d:1102, I am bothered 
that none of the Realtek drivers include this ID.

Before I ACK your patch, please download http://tinyurl.com/8by4obz, which is a 
non-mac80211 driver for the RTL8192CU for 9/22/2011, and try it. I have patched 
the Realtek version to build with kernels through 3.7 and to work with 64-bit 
systems. Your USB ID is included in the table.

Larry

