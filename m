Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:58715 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3GSXoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 19:44:02 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH 0/2] ath9k_htc fixes, resend
Date: Sat, 20 Jul 2013 01:43:51 +0200
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com
References: <1374257778-9758-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1374257778-9758-1-git-send-email-linux@rempel-privat.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201307200143.56632.s.L-H@gmx.de> (sfid-20130720_014406_546691_A4E4537C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Friday 19 July 2013, Oleksij Rempel wrote:
> Hi John,
> this patches needed to fix firmare/adapter hang issue on
> reboot or module reload.
> 
> Oleksij Rempel (2):
>   ath9k_htc: do some initial hardware configuration
>   ath9k_htc: reboot firmware if it was loaded

Given that this is a longstanding issue, affecting actual users, I'd 
suggest to "Cc: <stable@vger.kernel.org>" for these patches. They 
should meet the bar even under the new, stricter, interpretation of
the -stable rules and are small and self contained.

Regards
	Stefan Lippers-Hollmann
