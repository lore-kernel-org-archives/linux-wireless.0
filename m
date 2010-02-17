Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f178.google.com ([209.85.221.178]:60915 "EHLO
	mail-qy0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0BQSi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 13:38:56 -0500
Received: by qyk8 with SMTP id 8so2074111qyk.24
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 10:38:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266431764.15836.8.camel@jlt3.sipsolutions.net>
References: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
	 <4B7C35C9.30607@lwfinger.net>
	 <c2673ca61002171034q18edf1c2o817ac4e1ff367177@mail.gmail.com>
	 <1266431764.15836.8.camel@jlt3.sipsolutions.net>
Date: Wed, 17 Feb 2010 19:38:54 +0100
Message-ID: <c2673ca61002171038u14c7ab2fnf2d3ce2067bd1fd8@mail.gmail.com>
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
From: okias <d.okias@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, herton@mandriva.com.br,
	htl10@users.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You have probably right, but when I use my testing program:

#include <stdio.h>
main() {
int a;
printf("%i\n", a);
a |= 22;
printf("%i\n", a);
}

Output is:
0
22

it look correct to me


2010/2/17 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2010-02-17 at 19:34 +0100, okias wrote:
>> I did test on small C program, and "int a" is equal to int a = 0; so
>> it should be fine, but maybe I'm wrong.
>
> It's not equal. It will be uninitialised stack garbage if you don't
> initialise it.
>
> johannes
>



-- 
Jabber/XMPP: okias@isgeek.info
SIP VoIP: sip:17474537254@proxy01.sipphone.com
