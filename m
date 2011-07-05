Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2430 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1GEF7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 01:59:08 -0400
Message-ID: <4E12A81D.6000901@broadcom.com> (sfid-20110705_075913_577182_FB24EE42)
Date: Tue, 5 Jul 2011 07:58:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: lululatortue <lefrancoisfabien@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 14e4:4357 mode monitor
References: <loom.20110630T161632-452@post.gmane.org>
In-Reply-To: <loom.20110630T161632-452@post.gmane.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 04:34 PM, lululatortue wrote:
> Hello,
>
>       My objectif is to drive my broadcom with monitor mode. I would download the
> staging-next git tree, available at :
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>
>       but with my linux write:
>
>      git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>
>      I'have:
>
> Initialized empty Git repository in /home/lefrancois/staging-next-2.6/.git/
> fatal: The remote end hung up unexpectedly

The URL was wrong, see 
http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=summary

When the git:// URL still does not work, you can try the http:// variant.

I also noticed your objective. The monitor mode functionality is not 
(yet) supported by the brcm80211 softmac driver. Currently, it is a 
STA-only driver.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


