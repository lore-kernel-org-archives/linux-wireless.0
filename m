Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:57671 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbZCaJfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 05:35:32 -0400
Message-ID: <49D1E3D4.5040507@promwad.com> (sfid-20090331_113537_922691_ECCF9536)
Date: Tue, 31 Mar 2009 12:35:16 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
Reply-To: ivan.kuten@promwad.com
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 diversity
References: <49D0BD2B.9090102@promwad.com> <3ace41890903301208r5feda139w50a1eb7f6b717873@mail.gmail.com>
In-Reply-To: <3ace41890903301208r5feda139w50a1eb7f6b717873@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> On Mon, Mar 30, 2009 at 1:38 PM, Ivan Kuten <ivan.kuten@promwad.com> wrote:
>> Hello!
>>
>> Anybody is working on adding antenna diversity feature to rtl8187 driver?
> 
> Which of rtl8187 comes with multiple antenna, etc which would benefit
> from this feature?
> 

We are using WMG2503 module (with 2 antenna) from Abocom on our Blackfin DSP based board.
We did some preliminary work based on rtl8187L_linux_26.1036.1105.2008, however there are too
many unclear points.

Regards,
Ivan

>> Regards,
>> Ivan
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

