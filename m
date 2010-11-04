Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54938 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0KDOxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 10:53:15 -0400
Received: by gxk23 with SMTP id 23so1458464gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 07:53:15 -0700 (PDT)
Message-ID: <4CD2C8F4.5000309@lwfinger.net>
Date: Thu, 04 Nov 2010 09:53:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question about wireless configuration
References: <4CD2B6E9.9080303@lwfinger.net> <1288878640.10023.2.camel@Nokia-N900-51-1>
In-Reply-To: <1288878640.10023.2.camel@Nokia-N900-51-1>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2010 08:50 AM, Johannes Berg wrote:
>> I am trying to test the latest Realtek driver for the RTL8187L. In order
>> for the driver to be able to scan, CONFIG_WIRELESS_EXT must be set to
>> "y". I could find no way to do that with the kernel configuration
>> utilities until I made the following patch. I know it is wrong, but I
>> would like to know the correct way.
> 
> There is no correct way, drivers that need it will select it in kconfig which obviously doesn't work for out-of-tree drivers.

Thanks. I selected ZD1201 in the configuration, and WIRELESS_EXT is there.

Larry
