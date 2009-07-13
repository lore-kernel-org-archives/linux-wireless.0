Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbZGMS0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 14:26:20 -0400
Subject: Re: iwl3945 dropping from network
From: reinette chatre <reinette.chatre@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <87r5wl5alj.fsf@litku.valot.fi>
References: <87r5wl5alj.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 11:26:19 -0700
Message-Id: <1247509579.17896.1611.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, 2009-07-13 at 00:02 -0700, Kalle Valo wrote:
> Good morning,
> 
> during the weekend I have noticed that my iwl3945 is dropping from
> network and wpa_supplicant can't connect to the network anymore, only
> 'wpa_action wlan0 stop' (which essentially quits wpa_supplicant) and
> 'ifup wlan0' (which starts wpa_supplicant, debian is weird here) makes
> it work again. I think I'm seeing similar behaviour also when I resume.

I started seeing the exact same thing last friday with my 5100. In my
setup I am using networkmanager and it did not give me much debug
information when the problem occurred. I had to restart networkmanager
to be able to connect again. My logs look the same as yours though. I am
now running with wpa_supplicant in foreground with full debugging but so
far it has not happened yet.

Reinette


