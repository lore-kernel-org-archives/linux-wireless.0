Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h118.nextmail.ru ([194.67.36.118]:36165 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab2AFMvm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 07:51:42 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Fri, 06 Jan 2012 16:51:39 +0400
Message-ID: <NEXT-4f06ee5c00c505.33406970@nextmail.ru> (sfid-20120106_135158_288153_DA2CEC6D)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 >:(  i had put those warnings to prevent the crash itself and what's causing
 >it.
 > may be i had missed that pos can be < 0 in addition to (pos > 37).
 > i am just looking at those areas of code for some other issue. hope i
 > can a find a fix
 > for both of them

I am building kernel with pos<0 check added...

I hoped for some ad-hoc stress-test recommendation, but I guess this will have 
to wait. 


