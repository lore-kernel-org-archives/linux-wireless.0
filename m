Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:40976 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751122Ab0DIVxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 17:53:09 -0400
Message-ID: <4BBFA1BD.70900@free.fr>
Date: Fri, 09 Apr 2010 23:53:01 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 4/9] rt2x00: Remove rt2800 version	constants.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>	<1270763437-29526-5-git-send-email-gwingerde@gmail.com> <201004090032.53842.IvDoorn@gmail.com>
In-Reply-To: <201004090032.53842.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn a écrit :
> On Thursday 08 April 2010, Gertjan van Wingerde wrote:
>   
>> The rt2800 version constants are inconsistent, and the version number don't
>> mean a lot of things anyway. Use the literal values in the code instead of
>> some sort of fabricated version name macro.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>     
>
> Perhaps a more elegant way of using and defining needs to be found.
> But at least the defined show what the purpose for the values is
> rather then having magical values spread around the code.
>
> Ivo
>
>   
Agreed, it's a lot better to avoid hardcoded value. #define adds a 
meaning to the numeric value and if such define needs to be changed, 
there's only one place to change, avoiding bugs by duplicating hardcoded 
values and only changing one instance.

Even, #define MCS_0 0 is useful :-)

Regards,
Benoit

