Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:7325 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJ3AYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 20:24:45 -0400
Received: by wf-out-1314.google.com with SMTP id 27so270702wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 17:24:44 -0700 (PDT)
Subject: Re: B43 randomly and silently dropping connections...
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jerry McBride <mcbrides9@comcast.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081030001739.GG3485@tuxdriver.com>
References: <200810292010.06442.mcbrides9@comcast.net>
	 <20081030001739.GG3485@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 17:24:42 -0700
Message-Id: <1225326282.5496.5.camel@brick> (sfid-20081030_012449_923271_3699ABE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 20:17 -0400, John W. Linville wrote:
> On Wed, Oct 29, 2008 at 08:10:06PM -0400, Jerry McBride wrote:
> 
> > SHORT STORY:
> > -- Kernel 2.6.25.x with BCM43XX, firmware 4.80.53.0.. just perfect.
> > 
> > -- Kernels 2.6.26 or higher with B43 and firware 4.150.10.5 good negotiations, 
> > but fragile connections that drop randomly and without complaint. B43LEGACY 
> > does nothing.
> > 
> > Any help would be appreciated. I'd really like to get this ironed out. I 
> > highly desire to use current kernels.
> 
> Are you running a distro kernel?  Or one you have built yourself?
> 
> If the latter, have you opened a bug at bugzilla.kernel.org?
> Otherwise, have you opened a bug with your distro's bug tracking
> system?
> 
> Do you have wireshark captures taken with another device in monitor
> mode that show these connection drops?
> 
> Are you using NetworkManager or wpa_supplicant?  Or just configuring
> your connection with iwconfig?  If the latter, consider the former.
> If you are using NM, does the connection get re-established
> automatically?  Or is NM unable to reestablish the connection?
> Use wpa_supplicant directly if NM just doesn't work for you.
> 
> It seems clear that posting the same message to the mailing lists
> again and again is not resolving the issue for you.  Please perform
> the actions requested above (including opening a bug at the appropriate
> place) and collect some useable data for us.

In addition, have you tried updated firmware that was pointed to
http://thread.gmane.org/gmane.linux.kernel.wireless.general/22790

No idea if it will fix it or not.

Harvey

