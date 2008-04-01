Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2947 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394AbYDAREj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 13:04:39 -0400
Date: Tue, 1 Apr 2008 12:44:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luca Venturini <lucventurini@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: New IWL4935 driver for Intel Wireless Cards does not support
	WPA2 wireless network with PEAP - MSCHAPV2
Message-ID: <20080401164419.GA3530@tuxdriver.com> (sfid-20080401_180442_080435_4F22E2EC)
References: <47F1F4F4.2080502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47F1F4F4.2080502@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You probably want to address this to linux-wireless@vger.kernel.org
instead...

On Tue, Apr 01, 2008 at 10:40:20AM +0200, Luca Venturini wrote:
> Using Ubuntu Hardy Beta, Linux kernel 2.6.24, AMD64.
> I have to connect to a campus (University of Verona, Italy; more 
> information maybe available at https://wifi.univr.it sadly in Italian only, 
> and I am not sure it is reachable from outside the university) WPA2 
> wireless network. It uses PEAP authentication, Dynamic WEP encryption, 
> second phase: MSCHAPv2.
> It also requires user login, password, and a CA certificate (available at 
> the web page I linked above).
> At the same page a wpasupplicant configuration file is also available, so 
> to allow people to connect from linux also.
> In Ubuntu Gutsy 32 bit (Linux kernel 2.6.22.14 if I am not mistaken) I was 
> able to connect through NetworkManager and precisely using the GNOME 
> nm-applet.
> However, since I switched to Linux 2.6.24, I have no more been able to 
> connect, whether through NM-applet or from the command line, using 
> wpasupplicant. The wireless functions perfectly, and there has been no 
> change in its configuration, since I am using it now (Windows Vista, 
> configured months ago).
> Reported also here on launchpad: 
> https://bugs.launchpad.net/ubuntu/+bug/209602
> Thank you for your attention.
> Greetings
>
> Luca Venturini
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
John W. Linville
linville@tuxdriver.com
