Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:35068 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbaD2Htt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 03:49:49 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Tim Gardner <rtg.canonical@gmail.com>,
	Nicolas Vaquero <nicovaq92@hotmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel source
Date: Tue, 29 Apr 2014 09:42:16 +0200
Message-ID: <3262959.TlL8alHHte@bentobox> (sfid-20140429_094953_353501_442DB56B)
In-Reply-To: <535E7741.1030607@lwfinger.net>
References: <535E7741.1030607@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 April 2014 10:44:01 Larry Finger wrote:
[...]
> Is there a link to the 3.8.0-37 source? I could not find it on the Ubuntu
> web pile. With it, I should be able to fix his problem as long as I can
> duplicate it.

Which exact versions? 3.8.0-36.52~precise1 and 3.8.0-37.53~precise1? There were
a lot of backports which you can find all here:
https://launchpad.net/ubuntu/+source/linux-lts-raring/+publishinghistory

You can just click on the version number at the right to find the *.tar.gz,
*.diff.gz and *.dsc. 

You can download and create a source directory using 

dget https://launchpad.net/ubuntu/precise/+source/linux-lts-raring/3.8.0-36.52~precise1/+files/linux-lts-raring_3.8.0-36.52~precise1.dsc
or
dget https://launchpad.net/ubuntu/precise/+source/linux-lts-raring/3.8.0-37.53~precise1/+files/linux-lts-raring_3.8.0-37.53~precise1.dsc

Kind regards,
	Sven
