Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56938 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab0HPXvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 19:51:45 -0400
Received: by gxk23 with SMTP id 23so2135642gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 16:51:44 -0700 (PDT)
Message-ID: <4C69CEFE.2070209@lwfinger.net>
Date: Mon, 16 Aug 2010 18:51:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] p54: improve eeprom parser
References: <201008170116.58759.chunkeey@googlemail.com>
In-Reply-To: <201008170116.58759.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2010 06:16 PM, Christian Lamparter wrote:
> Like other vendors, p54* devices have a checksum for
> the EEPROM descriptor data. This patch enhances the
> parser code to generate and verify the data fields,
> before initializing the radio-chip on the card.
> 
> Note:
> 	If you have to bootstrap an alternative EEPROM image
> 	for your device and you don't know how to generate a
> 	valid crc ccitt checksum, you should take a look at:
> 	http://git.kernel.org/?p=linux/kernel/git/chr/p54tools.git
> 
> 	The "checksum" utility loads a binary p54 EEPROM blob
> 	(use the -f switch, to skip the check) and applies
> 	the correct crc automatically.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

ACK for p54usb.

Larry



