Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:57499 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab2JMJoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 05:44:20 -0400
Message-ID: <50793769.6070400@01019freenet.de> (sfid-20121013_114424_334133_957302F1)
Date: Sat, 13 Oct 2012 11:42:01 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Andreas Hartmann <andihartmann@01019freenet.de>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/7] rt2800: use BBP_R1 for setting tx
 power
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com> <506F0A56.70900@01019freenet.de> <20121008091523.GB2478@redhat.com> <20121013084720.45682744@dualc.maya.org> <20121013075728.GA2334@redhat.com>
In-Reply-To: <20121013075728.GA2334@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka wrote:
>> Just saw that I've been using this patchset since Aug 27, 2012 with my
>> AP (http://www.wikidevi.com/wiki/Linksys_WMP600N) and
>> compat-wireless-3.5-rc5-1 and linux 3.1.10
>>
>> iw list and iwconfig are showing always 0 dBm for each channel (2.4 and
>> 5 GHz).
> 
> For this you need another patch (which should be backported to 3.5 stable too):
> 
> commit 5e31fc0815a4e2c72b1b495fe7a0d8f9bfb9e4b4
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Tue Jul 24 08:35:39 2012 +0200
> 
>     wireless: reg: restore previous behaviour of chan->max_power calculations

Thanks Stanislaw. This fixed the output but nothing else :-(. 5 GHz is
broken anyway.


Thanks,
kind regards,
Andreas

