Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:48925 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYHAItr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 04:49:47 -0400
Date: Fri, 1 Aug 2008 11:50:22 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Tilman Schmidt <tilman@imap.cc>
Cc: me@felipebalbi.com, Greg KH <greg@kroah.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080801085022.GD23009@gandalf.research.nokia.com> (sfid-20080801_104951_062950_7E4E8574)
Reply-To: felipe.balbi@nokia.com
References: <4891D1B9.70703@imap.cc> <20080731163843.GB9606@kroah.com> <48922FE2.70705@imap.cc> <20080731215055.GB4817@kroah.com> <489242CF.2000100@imap.cc> <20080731232640.GB10436@frodo> <4892CD0C.7040403@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4892CD0C.7040403@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 01, 2008 at 10:45:00AM +0200, ext Tilman Schmidt wrote:
> -MODULE_LICENSE ("Proprietary");
> +MODULE_LICENSE ("GPL");

You can't change the module_license and publish it, dude :-p

anyways, I contacted the company yesterday night, let's see what they
reply.

-- 
balbi
