Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:48109 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297AbZIRSFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 14:05:04 -0400
Received: by ewy2 with SMTP id 2so1545332ewy.17
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 11:05:06 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: Makefile ref to non-existent CONFIG_ATHEROS_AR71XX
Date: Fri, 18 Sep 2009 20:04:51 +0200
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
References: <alpine.LFD.2.00.0909180959550.9988@localhost>
In-Reply-To: <alpine.LFD.2.00.0909180959550.9988@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909182004.54398.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robert,

Le vendredi 18 septembre 2009 16:01:25, Robert P. J. Day a écrit :
>   searching for Makefile references to Kconfig variables that don't
> exist, and i find:
>
> ===== ATHEROS_AR71XX =====
> ./drivers/net/wireless/ath/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) +=
> ahb.o

We need it in OpenWrt and plan to send Atheros AR71xx SoC support soon, do not 
consider this for removal. Thanks
-- 
Best regards, Florian Fainelli
Email: florian@openwrt.org
Web: http://openwrt.org
IRC: [florian] on irc.freenode.net
-------------------------------
