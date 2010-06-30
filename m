Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:48074 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750897Ab0F3GFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 02:05:34 -0400
Message-ID: <4C2ADEA5.2010009@free.fr>
Date: Wed, 30 Jun 2010 08:05:25 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Jono <koppah@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Subject: Re: [ath5k-devel] ath5k Register Question
References: <AANLkTikC3saJNwAFhHvSyJNqVF1fGPcVfn-hwGpR5V30@mail.gmail.com> <AANLkTinTDPyeV2QWWmXskp4504nxPIm1neJdxdLat51p@mail.gmail.com>
In-Reply-To: <AANLkTinTDPyeV2QWWmXskp4504nxPIm1neJdxdLat51p@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 30/06/2010 05:44, Jono a écrit :
> Hi,
>
> I'm not sure if this is the right place to ask, but I'm looking for
> information on a specific register on Atheros cards.
>
> I've been told that there is a register that Atheros chips update with
> information about how much of a set period has been detected as 'CCA'
> time. Unfortunately, I cannot find this information in the source
> code. The only register I found that matches this even closely appears
> to only be used during noise calibration, and not updated
> continuously.
>
> Any help would be greatly appreciated!
>
> Thank you,
>
> --
> Jonathan Guerin

Look for Profile Count Registers in ath5k/reg.h. Busy count is probably 
what you need.

Regards,
Benoit
