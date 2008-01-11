Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45158 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762579AbYAKWkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 17:40:13 -0500
Message-ID: <4787F03E.6080605@hauke-m.de> (sfid-20080111_224021_639371_DFEC3AF2)
Date: Fri, 11 Jan 2008 23:39:58 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: Michael Wu <flamingice@sourmilk.net>, linux-kernel@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187 rate control doesn't work
References: <477F9890.5050107@hauke-m.de>	 <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>	 <47824D25.5090005@hauke-m.de> <43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>
In-Reply-To: <43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Jan 7, 2008 11:02 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> 
> Thanks for reporting this, how'd it go with simple rate control
> algorithm instead?

How do I change from pid to simple rate control algorithm? I have tried
to set the CONFIG_MAC80211_RC_DEFAULT variable but it doesn't change the
 dmesg output. On kernel 2.6.22 simple rate control algorithm is used as
default but on 2.6.24 pid is the default on.

Can you please send me a config.mk

On kernel 2.4.24 with pid the rate shown by iwconfig stays at the
starting on, also if I change it with "sudo iwconfig wlan0 rate 11M", on
kernel 2.6.22 with simple rate control algorithm it shows the right rate.

If I change the rate to something smaller than 11M I am able to ping the
Access Point and if it is bigger that 11M I can't ping it. If no fixed
rate is entered it stays at 54MBit/s and I can't ping the AP. The
network speed is at ~1MBit/s and "Link Quality=53/64  Signal level=25/65"

I have a AMD64 System and I am using the compat-wireless-2.6 of today.

Hauke Mehrtens
