Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:36340 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab1LWL0H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 06:26:07 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Re3GG-0004h1-NP
	for linux-wireless@vger.kernel.org; Fri, 23 Dec 2011 12:26:04 +0100
Received: from localhost ([::1]:55551 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Re3GG-00072x-80
	for linux-wireless@vger.kernel.org; Fri, 23 Dec 2011 12:26:04 +0100
Received: from [195.4.92.19] (port=39286 helo=9.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Re3Dj-0005dP-Su
	for linux-wireless@vger.kernel.org; Fri, 23 Dec 2011 12:23:27 +0100
Received: from p4fde0343.dip0.t-ipconnect.de ([79.222.3.67]:48645 helo=mail.maya.org)
	by 9.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Re3Dj-0000O1-I0
	for linux-wireless@vger.kernel.org; Fri, 23 Dec 2011 12:23:27 +0100
Message-Id: <201112231123.pBNBNG7N003066@mail.maya.org> (sfid-20111223_122616_661763_813C4403)
Date: Fri, 23 Dec 2011 12:23:19 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: cf@cfrost.dk, linux-wireless@vger.kernel.org
Subject: Re: rt2800usb poor performance
In-Reply-To: <4EF44384.7070606@gmail.com>
References: <4EF44384.7070606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez schrieb:
> Christian Frost wrote:
> 
>> Yes, I have tried all your suggestions and they do not help. I
>> havedownloaded the firmware from ralinktech in version v2.4.0.1
> 
> The latest fw is at:
> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git
> 
> the fw of ralink web is outdated.

Hmmm. Example: chip rt3572 - firmware: rt2870.bin

from git: version is 0.29
from DPO_GPL_RT5572_LinuxSTA_V2.5.0.0_20111019 [1]: version is 0.236

(yes, this driver supports rt3572, too (I'm using it)).


BTW: I can't find any 5572 support in actual compat-wireless (I searched
for the rt55 string in all files).



Kind regards,
Andreas


[1] http://www.ralinktech.com/en/04_support/support.php?sn=501
