Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:51863 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYJ3UfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:35:13 -0400
Received: by ug-out-1314.google.com with SMTP id 39so1062349ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 13:34:27 -0700 (PDT)
Message-ID: <490A17F3.5050802@gmail.com> (sfid-20081030_213527_852044_44445DB3)
Date: Thu, 30 Oct 2008 20:24:19 +0000
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: Guidelines regarding separate directory
References: <4909EA78.3060700@lwfinger.net>	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
In-Reply-To: <1225387309.3690.73.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2008-10-30 at 10:10 -0700, Larry Finger wrote:
>> I am planning on adding code to control the LEDs on the RTL8187 devices based on
>> the latest vendor driver. From the expected size of the code, I think that
>> separate files will be best.
>>
>> What number of files in a driver make it advisable to create a separate
>> directory? Between the rtl8180 and rtl8187 drivers, there are now 15 files and I
>> will be adding at least 2 more. Is this the time to create a rtl818x directory
>> under drivers/net/wireless?
> 
> I for one think that should have been done already, makes finding
> drivers easier imho. But I don't think there are strict guidelines in
> any way.

On a similar note, would anyone object to collecting the orinoco files
in a subdirectory? I'm looking at doing some refactoring of orinoco.c
which I think can be split into at least 3 files.


Regards,

Dave.

PS the existing files that would move:
airport.c
hermes.c
hermes.h
hermes_dld.c
hermes_dld.h
hermes_rid.h
orinoco.c
orinoco.h
orinoco_cs.c
orinoco_pci.c
orinoco_pci.h
orinoco_plx.c
orinoco_tmd.c
orinoco_nortel.c
spectrum_cs.c
