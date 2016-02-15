Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:4373 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751182AbcBOL1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 06:27:11 -0500
From: "Kim, Leo" <Leo.Kim@atmel.com>
To: David Binderman <dcb314@hotmail.com>,
	"Kim, Johnny" <johnny.kim@atmel.com>,
	"Shin, Austin" <Austin.Shin@atmel.com>,
	"Park, Chris" <Chris.Park@atmel.com>,
	"Cho, Tony" <Tony.Cho@atmel.com>, "Lee, Glen" <Glen.Lee@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: drivers/staging/wilc1000/wilc_spi.c won't compile ?
Date: Mon, 15 Feb 2016 11:21:44 +0000
Message-ID: <74F3875218FC364C9618AB19CB60E90580048375@penmbx02.corp.atmel.com> (sfid-20160215_181511_050698_BC5B17F2)
References: <DUB128-W49FB60890BF7AB1D0892979CD50@phx.gbl>
In-Reply-To: <DUB128-W49FB60890BF7AB1D0892979CD50@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

You're had old wilc1000 source.
Remove the wilc1000_ops structure.
 (Branch) staging-testing
 (SHA) ce7b516f3f9e11fe4ee06fad0d7e853bb6e8f160
Please receive the latest source.

 Thanks, BR
 Leo

-----Original Message-----
From: David Binderman [mailto:dcb314@hotmail.com] 
Sent: Monday, February 08, 2016 9:18 PM
To: Kim, Johnny <johnny.kim@atmel.com>; Shin, Austin <Austin.Shin@atmel.com>; Park, Chris <Chris.Park@atmel.com>; Cho, Tony <Tony.Cho@atmel.com>; Lee, Glen <Glen.Lee@atmel.com>; Kim, Leo <Leo.Kim@atmel.com>; linux-wireless@vger.kernel.org
Subject: drivers/staging/wilc1000/wilc_spi.c won't compile ?

Hello there,

drivers/staging/wilc1000/wilc_spi.c:123:34: error: storage size of 'wilc1000_spi_ops' isn't known
 static const struct wilc1000_ops wilc1000_spi_ops;
                                  ^~~~~~~~~~~~~~~~
drivers/staging/wilc1000/wilc_spi.c:123:34: warning: 'wilc1000_spi_ops' defined but not used [-Wunused-const-variable]

Suggest remove.

Regards

David Binderman

 		 	   		  
