Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47766 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3IEOBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 10:01:09 -0400
Received: by mail-qa0-f49.google.com with SMTP id w8so916466qac.8
        for <linux-wireless@vger.kernel.org>; Thu, 05 Sep 2013 07:01:06 -0700 (PDT)
Message-ID: <52288EA0.9070802@gmail.com> (sfid-20130905_160113_189283_02B64673)
Date: Thu, 05 Sep 2013 10:01:04 -0400
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: abbas.chunawala@slscorp.com
CC: linux-wireless@vger.kernel.org
Subject: Re: Error:ACS not working even after the Makefile and the configuration
 options are set.
References: <52286C01.6080303@slscorp.com>
In-Reply-To: <52286C01.6080303@slscorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2013 07:33 AM, Abbas Chunawala wrote:
> Hi,
> Greetings.
>
> No ACS prints.
> Instead an error
> ath0 : IEEE 802.11 : Fetching channel rate/frequency not supported
^ You seem to be using the driver MadWiFi instead of Ath5k based upon
the interface name. MadWiFi is deprecated in support of the Ath5k driver.

You need to blacklist MadWiFi first before loading Ath5k.
> The channel variable is set right in the configuration file.
> How to get the acs prints.
> The command for the hostapd invocation is a s follows:-
> hostapd -B /tmp/secath0 -dd -e /etc/wpa2/entropy.
>
> Thanks
> Regards
> Abbas Chunawala
> (System Level Solutions (I) Pvt. Ltd. )
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

