Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbYDBRy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 13:54:57 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: 2.6.25-rc8-mm1 -- drivers/net/wireless/iwlwifi/iwl-led.c:184: error: 'struct iwl_priv' has no member named 'last_blink_time'
Date: Wed, 2 Apr 2008 10:52:14 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004194769@orsmsx416.amr.corp.intel.com> (sfid-20080402_185503_055663_D3BD0A75)
In-Reply-To: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
References: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Miles Lane" <miles.lane@gmail.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"LKML" <linux-kernel@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 02, 2008 4:04 AM, Miles Lane  wrote:

>  CC [M]  drivers/net/wireless/iwlwifi/iwl-led.o
> drivers/net/wireless/iwlwifi/iwl-led.c: In function
> 'iwl4965_led_associated': drivers/net/wireless/iwlwifi/iwl-led.c:184:
> error: 'struct iwl_priv' has no member named 'last_blink_time'
> drivers/net/wireless/iwlwifi/iwl-led.c:184: error: 'struct iwl_priv'
> has no member named 'allow_blinking'
> drivers/net/wireless/iwlwifi/iwl-led.c:185: error: 'struct iwl_priv'
> has no member named 'last_blink_time'
> drivers/net/wireless/iwlwifi/iwl-led.c: In function
> 'iwl4965_led_brightness_set':

Another problem with iwlwifi config variables. A fix has just been sent
to wireless-testing ("iwl4965: use IWLWIFI_LEDS config variable").

Thanks!

Reinette
