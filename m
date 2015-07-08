Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42899 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbbGHA4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 20:56:46 -0400
From: "Kim, Johnny" <johnny.kim@atmel.com>
To: 'David Binderman' <dcb314@hotmail.com>,
	"Kim, Rachel" <Rachel.Kim@atmel.com>,
	"Lee, Dean" <Dean.Lee@atmel.com>,
	"Park, Chris" <Chris.Park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: linux-4.2-rc1/drivers/staging/wilc1000/linux_wlan.c:1874: bad
 test ?
Date: Wed, 8 Jul 2015 00:56:14 +0000
Message-ID: <3860A773274B9F4F94F72A20E848602354C1419D@penmbx02.corp.atmel.com> (sfid-20150708_025658_542684_0B948B9D)
References: <DUB128-W333766FA47F8690AEA26469C920@phx.gbl>
In-Reply-To: <DUB128-W333766FA47F8690AEA26469C920@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello David.

Thanks for your detail review.
The code is wrong and will be removed because of unused code later.

Regards.
Johnny.

-----Original Message-----
From: David Binderman [mailto:dcb314@hotmail.com] 
Sent: Tuesday, July 07, 2015 8:19 PM
To: Kim, Johnny; Kim, Rachel; Lee, Dean; Park, Chris; linux-wireless@vger.kernel.org
Subject: linux-4.2-rc1/drivers/staging/wilc1000/linux_wlan.c:1874: bad test ?

Hello there,

[linux-4.2-rc1/drivers/staging/wilc1000/linux_wlan.c:1874]: (style) A pointer can not be negative so it is either pointless or an error to check if it is.

Source code is

     if (wilc_mac_thread < 0) {

but

struct task_struct *wilc_mac_thread;

Regards

David Binderman

 		 	   		  
