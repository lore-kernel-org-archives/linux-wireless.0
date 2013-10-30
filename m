Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:40283 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3J3O3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 10:29:36 -0400
Received: from smtp08.msg.oleane.net (smtp08.mail.priv [172.17.20.117])
	by smtp-out03.msg.oleane.net with ESMTP id r9UETYHc003452
	for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 15:29:34 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp08.msg.oleane.net (MTA) with ESMTP id r9UE8gs9025764
	for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 15:08:42 +0100
Subject: ath9k EEPROM change
Date: Wed, 30 Oct 2013 15:08:41 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Message-ID: <773DB8A82AB6A046AE0195C68612A3190164BA54@sbs2003.acksys.local> (sfid-20131030_152939_071811_69B60BC6)
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	I have an issue with the wireless card in temperature around 5°C.

	This card using an AR9xxx chipset.

	To fix my issue I need to change several values in EEPROM (xlna gain, cca threshold, noise floor threshold in 2.4 and 5 GHz band). 

	I know is not possible to write the EEPROM register with ATH9K.

	I looking for in the driver and I found the function ath9k_hw_def_set_board_values in eeprom_def.c. In this function, the cca threshold is set to the value 28.

	Is it possible to change all needed EEPROM value with this function? 
	Is it use for all ath9k chipset?

	If is not possible with this function, have you another solution?

	Thanks for your help.
	                
Cedric Voncken 


