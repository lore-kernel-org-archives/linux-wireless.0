Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55082 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526Ab2FASAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 14:00:48 -0400
Received: by yenm10 with SMTP id m10so1995879yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2012 11:00:47 -0700 (PDT)
Message-ID: <4FC9034C.803@lwfinger.net> (sfid-20120601_200052_764605_73AA46A8)
Date: Fri, 01 Jun 2012 13:00:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jacopo Runchi <jacoporunchi@hotmail.it>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: R: I: RTL8187 driver in linux 3.4
References: <!&!AAAAAAAAAAAuAAAAAAAAAH2SKMTPZA1PmAOs8RWvl9YBANlTnCJhprtFudq2LHCBs8EBACQA//8AABAAAACIF7qVX5kVSJrDEtYsG/e+AQAAAAA=@hotmail.it> <DUB107-ds5BA2D5341A3C373209B17A0080@phx.gbl> <4FC8E733.6030905@lwfinger.net> <DUB107-ds643010AABCBACB5BC945BA0080@phx.gbl>
In-Reply-To: <DUB107-ds643010AABCBACB5BC945BA0080@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2012 11:45 AM, Jacopo Runchi wrote:
> Hi, thanks for your answer.
>> From what I was able to understand, the old driver uses the ieee8011 stack,
> and the new uses the mac80211.
> Since I'm neither a newbie, nor an expert, I don't know if the sentence has
> a real meaning...
>
> The try about the rate has already been tested. No changes locking it. Same
> results with the automatic rate, with rate 1 mbps and with 54 mbps...
> Maybe I can send you the device id in lsusb, this evening or during the next
> days, since now I flashed the old 2.4 release and I need to reflash the
> device with the new kernel.
 >
> For what concern the "PID rate-setting algorithm" setting "CONFIG_EXPERT=y"
> I don't know anything...
> I'm going to search for it on the net and I will try it too.

Is lsusb not available in the 2.4 system?

DO NOT DROP the wireless list from the Cc. Doing so converts the exchange back 
to a private one, and I will ignore further messages if you do that. It is also 
better if you bottom post. That way a reader can go through the background material.

The 2.4 driver used its own built-in softmac 802.11 stack. Mac80211 is a 
replacement for it. Although mac80211 has a great deal more functionality, they 
generally do the same things.

Larry
