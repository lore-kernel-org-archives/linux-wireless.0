Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h118.nextmail.ru ([194.67.36.118]:59563 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab2ARRas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 12:30:48 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Wed, 18 Jan 2012 21:30:38 +0400
Message-ID: <NEXT-4f1701be44f182.23501812@nextmail.ru> (sfid-20120118_183109_750516_FF2B2085)
Mime-Version: 1.0
Content-type: text/plain;
	 charset="koi8-r"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > 2012/1/18 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:

 >> š> I wonder if maybe a congested AP could help.. But unclear how to
 >obtain
 > > š> that quickly and reliably.
 > >
 > > Even with debugging off WiFi works reliably across different 
conditions.
 > >
 > 
 > you can test frequent roaming with the attached script. also you can
 > test roaming, after enabling ASPM(attached script, courtesy: Luis)
 > please completely read and understand
 > http://linuxwireless.org/en/users/Documentation/ASPM
 > incorrect tweak may cause hardware issues.

Well, when I got the failure, exactly one roaming attempt happenned...

ASPM seems disabled and from what I understood, it is a Bad Idea to enable 
it before fully understanding why exactly it was disabled. I have no time to 
acquire this understanding now.

I read the roaming script. I need to get the scan results and then issue 
"roam" in loop between all the APs I can access, right? Will try just to 
collect some new testing data.

Thanks for the patch - looks like it works fine so far.


