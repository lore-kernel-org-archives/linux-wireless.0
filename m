Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3E3WxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 18:53:05 -0400
Date: Fri, 31 May 2013 07:13:39 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH V3.10] rtlwifi: rtl8192cu: Fix problem in connecting to
 WEP or WPA(1) networks
Message-ID: <20130530221339.GA1630@kroah.com> (sfid-20130531_005310_484829_D34BB44F)
References: <1369949040-9513-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369949040-9513-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 30, 2013 at 04:23:30PM -0500, Larry Finger wrote:
> Driver rtl8192cu can connect to WPA2 networks, but fails for any other
> encryption method. The cause is a failure to set the rate control data
> blocks. These changes fix https://bugzilla.redhat.com/show_bug.cgi?id=952793
> and https://bugzilla.redhat.com/show_bug.cgi?id=761525.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This patch is pretty large for this stage; however, it fixes a bad bug, and
> it will only affect rtl8192cu even though it touches rtlwifi.
> 
> I held it for a while while Fedora and RHEL users tried it and responded.
> As you well know, that can take a while.


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
