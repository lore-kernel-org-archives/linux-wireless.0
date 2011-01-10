Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.3eti.com ([65.220.88.141]:15803 "EHLO webmail.3eti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1AJOu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 09:50:59 -0500
From: Chaoxing Lin <CLin@3eti.com>
To: 'Jouni Malinen' <j@w1.fi>
CC: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: RE: hostapd hangs on quit, multi-BSSID scenario
Date: Mon, 10 Jan 2011 14:51:09 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D05716091@RockMX01.rock.corp>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D85@RockMX01.rock.corp>
 <20110109172629.GA12229@jm.kir.nu>
In-Reply-To: <20110109172629.GA12229@jm.kir.nu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks very much.

It works very well now.

-----Original Message-----
From: Jouni Malinen [mailto:j@w1.fi] 
Sent: Sunday, January 09, 2011 12:26 PM
To: Chaoxing Lin
Cc: 'linux-wireless@vger.kernel.org'
Subject: Re: hostapd hangs on quit, multi-BSSID scenario

On Fri, Jan 07, 2011 at 05:44:30PM +0000, Chaoxing Lin wrote:
>  When I run hostapd with 8+1 BSSID over one radio (ath9160), it runs well. All 9 BSS accepts clients.
> But when I "Ctrl + C" or "killall hostapd", hostapd daemon can NOT gracefully shut down. It hangs forever. I have to "Ctrl + C" again. Then it quits and print message like "

> ^Celoop: could not process SIGINT or SIGTERM in two seconds. Looks like there
> is a bug that ends up in a busy loop that prevents clean shutdown.
> Killing program forcefully.

Fixed here:
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=8546ea19301f31e5faf58a0f154773c3123e6474

-- 
Jouni Malinen                                            PGP id EFC895FA

