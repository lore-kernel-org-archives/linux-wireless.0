Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44061 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921Ab1AIR0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 12:26:33 -0500
Date: Sun, 9 Jan 2011 19:26:29 +0200
From: Jouni Malinen <j@w1.fi>
To: Chaoxing Lin <CLin@3eti.com>
Cc: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: Re: hostapd hangs on quit, multi-BSSID scenario
Message-ID: <20110109172629.GA12229@jm.kir.nu>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D85@RockMX01.rock.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D85@RockMX01.rock.corp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
