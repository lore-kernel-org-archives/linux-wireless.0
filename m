Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65484 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1LKAfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 19:35:22 -0500
Received: by ggdk6 with SMTP id k6so59948ggd.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 16:35:21 -0800 (PST)
Message-ID: <4EE3FAC6.9090406@lwfinger.net> (sfid-20111211_013530_375335_8EA93844)
Date: Sat, 10 Dec 2011 18:35:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: 651622@bugs.debian.org, Roland Gruber <post@rolandgruber.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Bug#651622: linux-2.6: Sitecom WLA-2000 v1.001 WLAN stick not
 supported
References: <20111210162607.1020.50335.reportbug@roland> 		 <1323537258.18450.100.camel@deadeye> <4EE39C40.4030802@rolandgruber.de> 	 <1323543622.25752.4.camel@deadeye> <4EE3D447.7030108@rolandgruber.de>  <1323554710.25752.18.camel@deadeye> <4EE3DF19.6080106@rolandgruber.de>  <4EE3E9A1.8000004@lwfinger.net> <1323561071.25752.20.camel@deadeye>
In-Reply-To: <1323561071.25752.20.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 05:51 PM, Ben Hutchings wrote:
> On Sat, 2011-12-10 at 17:22 -0600, Larry Finger wrote:
>> If rtl8192cu generates an oops when you use the new_id, then it is the wrong
>> driver for your device.
>
> Isn't this really just because using new_id results in
> driver_info = NULL?

I'm not sure, but I think new_id worked in the past for this driver.

Let's see if r8712u works. On Sunday night, I'll send the USB ID to the Realtek 
people in Taiwan. From experience, I know I won't get a response on the weekend.

Larry
