Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46954 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab2E3XAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 19:00:36 -0400
Message-ID: <4FC6A68D.1010002@hauke-m.de> (sfid-20120531_010039_783579_FDB14AD9)
Date: Thu, 31 May 2012 01:00:29 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Jean-Pierre TOSONI <jp.tosoni@acksys.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: Is there a changelog for compat wireless ?
References: <773DB8A82AB6A046AE0195C68612A319012CA16F@sbs2003.acksys.local>
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319012CA16F@sbs2003.acksys.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 07:54 PM, Jean-Pierre TOSONI wrote:
> Hello all,
> 
> I am looking for indications as what is changing from one version of
> compat-wireless to the next.
> 
> The link for the changelog given at
>  http://linuxwireless.org/en/users/Download#compat-wireless_ChangeLog 
> is broken.
> 
> Is there some other place where I can find it ? ww.orbit-labs.org has
> many, is it that the changes to the wireless software is not backported
> in the same way to all (supported) versions of the kernel ?
> 
> Thanks,
> 
> Jean-Pierre Tosoni
Hi

The changelog for compat-wireless is here:
https://github.com/mcgrof/compat-wireless/commits/master
for compat here:
https://github.com/mcgrof/compat/commits/master
and for wireless-testing here:
https://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=shortlog

Hauke
