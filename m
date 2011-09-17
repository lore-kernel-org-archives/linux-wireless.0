Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38683 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab1IQONV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 10:13:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by hauke-m.de (Postfix) with ESMTP id A03828DF7
	for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 16:13:20 +0200 (CEST)
Received: from hauke-m.de ([127.0.0.1])
	by localhost (hauke-m.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A1Qw+k4z39Ik for <linux-wireless@vger.kernel.org>;
	Sat, 17 Sep 2011 16:13:16 +0200 (CEST)
Received: from [192.168.178.21] (dyndsl-085-016-166-085.ewe-ip-backbone.de [85.16.166.85])
	by hauke-m.de (Postfix) with ESMTPSA id 576378DF1
	for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 16:13:16 +0200 (CEST)
Message-ID: <4E74AAFB.8070708@hauke-m.de> (sfid-20110917_161325_120475_36A9BF21)
Date: Sat, 17 Sep 2011 16:13:15 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Compat-wireless release based on wireless-testing
References: <4E73B822.5010403@hauke-m.de>
In-Reply-To: <4E73B822.5010403@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I made a new version based on wireless-testing master-2011-09-16.

It is available at
http://hauke-m.de/files/compat-wireless/compat-wireless-wl-2011-09-17.tar.bz2

Hauke

On 09/16/2011 10:57 PM, Hauke Mehrtens wrote:
> As kernel.org is still down and no new version of linux-next is
> available I created a compat-wireless version based on recent
> wireless-testing ( master-2011-09-14 ).
> 
> It can be downloaded here and is compile tested with all last kernel
> minor version >= 2.6.27:
> http://hauke-m.de/files/compat-wireless/compat-wireless-wl-2011-09-16.tar.bz2
> 
> The source code for compat-wireless can be fond on github:
> compat-wireless: https://github.com/hauke/compat-wireless/tree/hauke-wl
> compat: https://github.com/hauke/compat/tree/hauke
> 
> This release was created manually and I plan to do other releases when
> wireless-testing updates, till no new version of linux-next is
> available, but I will not promise anything. ;-)
> 
> Have fun with the recent wireless code.
> 
> Hauke

