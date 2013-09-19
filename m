Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:43512 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab3ISJFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 05:05:12 -0400
Message-ID: <20130919090510.24365.qmail@stuge.se> (sfid-20130919_110517_625260_07B59EEE)
Date: Thu, 19 Sep 2013 11:05:09 +0200
From: Peter Stuge <peter@stuge.se>
To: users@rt2x00.serialmonkey.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] RT3573 wpa_supplicant: "nl80211: Delete station
	$my_ap" after "SME: Send 20/40 BSS Coexistence to $my_ap"
References: <5239A815.40909@gmail.com> <20130918154233.31983.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130918154233.31983.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Stuge wrote:
> I am on linux.git commit d8efd82eece89f8a5790b0febf17522affe9e1f1
> which contains commit f212781, current wireless-next/master HEAD.
..
> Do you suspect that my problem (as described briefly in the email
> subject and with more detail after the part of my email which you
> quoted) is related to the device driver rather than higher-up parts
> of the stack?
..
> > You can also try latest fw(v0.33):
> > http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/attachments/20130111/f8ebe4d3/attachment.bin
> 
> Thanks! Will try this and get back to you.

With the above firmware the problem described briefly in Subject and
in more detail in my original email occurs much more easily, even as
I am actively generating traffic over the interface. It happened
twice while I was composing this very short email.


//Peter
