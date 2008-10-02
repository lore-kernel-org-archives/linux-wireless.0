Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:12319 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYJBRoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 13:44:15 -0400
Received: by ey-out-2122.google.com with SMTP id 6so403834eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 10:44:13 -0700 (PDT)
Message-ID: <48E50862.3030205@gmail.com> (sfid-20081002_194422_397638_836C466A)
Date: Thu, 02 Oct 2008 18:44:02 +0100
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: Dave <kilroyd@googlemail.com>, Greg KH <greg@kroah.com>,
	TJ <linux@tjworld.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Casual J. Programmer" <casualprogrammer@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Alexander Shirshikov <alexander.shirshikov@gmail.com>
Subject: Re: Agere Hermes source-code: copyright situation
References: <200809290949.35749.arvidjaar@mail.ru> <20081001200039.GA29874@kroah.com> <48E400FA.2090305@gmail.com> <200810020637.27321.arvidjaar@mail.ru>
In-Reply-To: <200810020637.27321.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
>> FYI, Hermes I hardware is already covered by the orinoco driver. WPA and firmware download functionality (which is supported by the Agere driver, but not orinoco in 2.6.27) is already in the wireless queue for 2.6.28.
>>
> 
> Yes, I discovered this yesterday as well. Thank you!
> 
> How are you going to distribute firmware? You will need 9.x firmware from
> original Agere driver; do I understand it correctly that it will come
> with orinoco in binary form?

I was hoping we could get it into David Woodhouses firmware tree. However I haven't had a response to my original message. I'll try again with a patch.


Dave.
