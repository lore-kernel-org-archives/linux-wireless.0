Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48913 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3CUS1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 14:27:35 -0400
Received: by mail-oa0-f46.google.com with SMTP id k1so3446500oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 11:27:34 -0700 (PDT)
Message-ID: <514B5113.3030501@lwfinger.net> (sfid-20130321_192739_958237_7635F05D)
Date: Thu, 21 Mar 2013 13:27:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Support for Realtek USB PID 0bda:1724 (rtl8723a?)
References: <1363889497.6412.18.camel@dcbw.foobar.com>
In-Reply-To: <1363889497.6412.18.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2013 01:11 PM, Dan Williams wrote:
> Hi,
>
> I've gotten a few questions about this device and wondered if support
> for this is feasible; it's not in any of the rtlwifi vid/pid lists yet.
>
> Some Internet Thread says there's a vendor driver here:
>
> http://dl.dropbox.com/u/57056576/DRIVERS/REALTEK/rtl_92ce_92se_92de_8723ae_linux_mac80211_0006.0514.2012.tar.gz
>
> but I failed to find the USB IDs for that device in here.

That driver is for the RTL8723AE, and other PCI-based devices. There is no USB 
code in it.

I personally have never seen an RTL8723AU, which would be the proper designation 
for a USB device with the 8723A chip.

Do you have a link as to what devices have this chip? I am interested in adding 
it to my collection, and getting a driver for it into the kernel.

Larry

