Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46858 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008Ab0KMBuj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:50:39 -0500
Message-ID: <4CDDEEEA.2030000@openwrt.org>
Date: Sat, 13 Nov 2010 02:50:34 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com
Subject: Re: [PATCH v3 2/9] ath5k: Introduce ath5k_init_softc function as
 in ath9k
References: <1289577459-4276-1-git-send-email-Wojciech.Dubowik@neratec.com> <1289577459-4276-3-git-send-email-Wojciech.Dubowik@neratec.com>
In-Reply-To: <1289577459-4276-3-git-send-email-Wojciech.Dubowik@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-12 4:57 PM, Wojciech Dubowik wrote:
> Split pci initialization into hardware specific
> functions and softc structure initialization.
> Make function naming similar to ones ath9k.
> Introduce ath_bus_opts in ath5k for later
> AHB bus integration.
> 
> From: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
The 'From:' part only works if it's put in the first line of the message
body.

- Felix
