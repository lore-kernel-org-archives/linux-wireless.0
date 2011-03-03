Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:43439 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1CCMle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 07:41:34 -0500
Message-ID: <4D6F8B9F.6070508@pardus.org.tr>
Date: Thu, 03 Mar 2011 14:37:51 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] staging: rtl8192e: Fix incorrect netif_stop_queue usage
 warning
References: <1298964192-13074-1-git-send-email-ozan@pardus.org.tr> <20110301211523.GA19958@kroah.com> <4D6D688C.7090605@pardus.org.tr> <20110301220130.GA25594@kroah.com> <4D6D6D7C.7090808@pardus.org.tr>
In-Reply-To: <4D6D6D7C.7090808@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

02-03-2011 00:04 tarihinde, Ozan Çağlayan yazdı:
> On 02.03.2011 00:01, Greg KH wrote:
> 
>> That's why it doesn't apply, I need patches against the linux-next tree
>> for stuff to go into the .39 kernel version.  Care to rediff this
>> against that one and resend it?

OK this was already fixed with

commit 6376f210aeca59c89c67efe8ccf28c36bb98b832
Author: Mike McCormack <mikem@ring3k.org>
Date:   Mon Jan 31 22:09:15 2011 +0900

    Staging: rtl8192e: Don't mess with carrier before registering device

    Signed-off-by: Mike McCormack <mikem@ring3k.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

in linux-next. Sorry :)

Regards,
Ozan Caglayan


-- 
Pardus Linux
http://www.pardus.org.tr/eng
