Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ammma.de ([213.83.39.131]:28752 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752076AbZBTPFT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 10:05:19 -0500
Received: from ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id n1KF7AI09746
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 16:07:10 +0100
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by ammma.net (8.12.11.20060308/8.12.11/AMMMa AG) with ESMTP id n1KF5FQO003354
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 16:05:16 +0100
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 63D8D41B42B
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 16:05:15 +0100 (CET)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sC3m5rOZ8SAb for <linux-wireless@vger.kernel.org>;
	Fri, 20 Feb 2009 16:05:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 9A7A8436172
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 16:05:02 +0100 (CET)
Message-ID: <20090220160502.112039tfocopragw@neo.wg.de> (sfid-20090220_160523_747379_1066EAD3)
Date: Fri, 20 Feb 2009 16:05:02 +0100
From: Jan Schneider <jan@horde.org>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Connection "interruptions"
References: <20090216143915.18703m2wpmqic1ic@neo.wg.de>
In-Reply-To: <20090216143915.18703m2wpmqic1ic@neo.wg.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zitat von Jan Schneider <jan@horde.org>:

> Hi,
>
> now that I got current wireless-compat snapshots running at all, I'm  
> back to look into what I hoped had been fixed in newer versions:
> I see arbitrary "interruptions" of the wireless connection. The  
> transfer just halts for a few seconds, no traffic is going over the  
> ether at all. Then suddenly, the connection resumes as if nothing  
> happened. Nothing is being logged by kernel, wpa_supplicant or  
> syslog. This is a draft-n-only thing, it does not happen if I tell  
> either the AP or the driver module to not use draft-n. This is an  
> Intel 5300 board.
> I am wondering how to further track this down, or how to collect  
> useful data for a bug report. Logging everything with the debug flag  
> is probably not very helpful, since this produces huge logs, and  
> it's not easy to determine the exact point when the connection  
> drops. What might be useful flags for the debug50 parameter to get  
> more information from the driver without getting lost in the sheer  
> amount of debug messages?

No suggestions, anyone?

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/

