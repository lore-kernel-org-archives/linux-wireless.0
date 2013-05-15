Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547Ab3EORnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 13:43:02 -0400
Message-ID: <5193C8FB.3070408@infradead.org> (sfid-20130515_194330_832413_FFCABB34)
Date: Wed, 15 May 2013 10:42:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: Re: linux-next: Tree for May 15 (wireless/brcm)
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
In-Reply-To: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/13 20:26, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130514:
> 

on x86_64:

drivers/built-in.o: In function `brcms_led_unregister':
(.text+0x136f0e): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `brcms_led_register':
(.text+0x1370b5): undefined reference to `led_classdev_register'

when CONFIG_NEW_LEDS is not enabled.


-- 
~Randy
