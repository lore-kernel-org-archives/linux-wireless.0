Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h118.nextmail.ru ([194.67.36.118]:58323 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab2ALSEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 13:04:44 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Thu, 12 Jan 2012 22:04:41 +0400
Message-ID: <NEXT-4f0f20b95e2525.38731543@nextmail.ru> (sfid-20120112_190449_751939_48FAF3F7)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > 2012/1/11 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
 > >> does roaming seems to trigger this issue consistently ?
 > >> . please provide the logs
 > >> sudo modprobe -v ath9k debug=0xffffffff
 > >> http://linuxwireless.org/en/users/Drivers/ath9k/debug
 > >
 > > As I need to rebuild for CONFIG_ATH_DEBUG: should I check the 
allegedely
 > > proper fix or wide-angle code removal first?
 > 
 > please check with the proper fix

Turned out I got lucky previous time.

This time I went to the other AP, spent some time under it, roamed back and 
WiFi didn't disappear. I didn't even lose XMPP connections in the process. 

Maybe debug printing (which prints a lot) managed to introduce some extra 
delays into some race condition.

I hope I will have time to test this more on Monday. Tomorrow I will be 
using WiFi less than usual.


