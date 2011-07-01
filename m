Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4015 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab1GAT3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 15:29:50 -0400
Message-ID: <20110701152949.wktyhphv6884ww4s-cebfxv@webmail.spamcop.net> (sfid-20110701_212954_511367_D371B272)
Date: Fri, 01 Jul 2011 15:29:49 -0400
From: Pavel Roskin <proski@gnu.org>
To: Alex <alex9434@gmail.com>
Cc: Omar Abraham <omar.abraham@upr.edu>, linux-wireless@vger.kernel.org
Subject: Re: Compile error in carl9170 on Debian Squeeze
References: <BANLkTimsGJo61eLp3NrVtDkh0m3CN3zDxw@mail.gmail.com>
	<4E0B8A61.8090600@upr.edu> <4E0B8E35.8080203@gnu.org>
	<BANLkTikEqPt1NkPr99Cfp_Rfp63z3s669Q@mail.gmail.com>
In-Reply-To: <BANLkTikEqPt1NkPr99Cfp_Rfp63z3s669Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Alex <alex9434@gmail.com>:

> Pavel, Omar and all,
>
> thank you very much for your support. However, I still get the error message:
>
>                  from <command-line>:0:
> /usr/src/compat-wireless-2011-06-30/include/linux/compat-2.6.34.h:23:
> error: redefinition of 'netdev_name'

It takes some time to propagate patches.  The patch appeared in  
compat-wireless-2011-07-01, which is available now.

> BTW: One more question: There seems to be a module "carl9170" in the
> 2.6.39.2 kernel. Does this replace compat-wireless? Do I only need
> this module to get the wlan in monitor mode? (please excuse my
> question, I am really new to this...)

You can try it.  The point of compat-wireless is to make the current  
wireless drivers available for older kernels.  If you kernel is not so  
old, you make have the functionality you need in your kernel already.   
But if you want to use the older Debian kernel, compat-wireless is the  
only option.

-- 
Regards,
Pavel Roskin
