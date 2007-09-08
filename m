Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:61550 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbXIHHhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 03:37:24 -0400
Received: by py-out-1112.google.com with SMTP id u77so1392197pyb
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 00:37:24 -0700 (PDT)
Message-ID: <1ba2fa240709080037p44516f1eu7040bd4424a29f8c@mail.gmail.com>
Date: Sat, 8 Sep 2007 10:37:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi sparse warnings with __CHECK_ENDIAN__
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1189100027.28781.104.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1189100027.28781.104.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure that you are running latest iwlwifi.
There is only one warning with __CHECK_ENDIAN__ which I don't know how
to solve cleanly.
Yet the code is correct and it is even running on a  PPC machine.

Tomas

On 9/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> drivers/net/wireless/iwl-3945.c:949:3: warning: incorrect type in argument 3 (different base types)
> drivers/net/wireless/iwl-3945.c:949:3:    expected int
> drivers/net/wireless/iwl-3945.c:949:3:    got restricted unsigned short [usertype] board_revision
> drivers/net/wireless/iwl-3945.c:954:3: warning: incorrect type in argument 3 (different base types)
> drivers/net/wireless/iwl-3945.c:954:3:    expected int
> drivers/net/wireless/iwl-3945.c:954:3:    got restricted unsigned short [usertype] board_revision
> drivers/net/wireless/iwl-3945.c:1650:15: warning: cast from restricted type
> drivers/net/wireless/iwl-base.c:1703:17: warning: cast to restricted type
> drivers/net/wireless/iwl-base.c:2168:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2168:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2168:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2169:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2169:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2169:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2170:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2170:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2170:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2171:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2171:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2171:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2172:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2172:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2172:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2178:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2178:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2178:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2180:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2180:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2180:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2182:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2182:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2182:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2184:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2184:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2184:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2185:4: warning: incorrect type in initializer (different base types)
> drivers/net/wireless/iwl-base.c:2185:4:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2185:4:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2220:16: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/iwl-base.c:2220:16:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2220:16:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2222:16: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/iwl-base.c:2222:16:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2222:16:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2267:14: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/iwl-base.c:2267:14:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2267:14:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2271:14: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/iwl-base.c:2271:14:    expected restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-base.c:2271:14:    got restricted unsigned int [usertype] [force] <noident>
> drivers/net/wireless/iwl-base.c:2279:2: warning: incorrect type in argument 3 (different base types)
> drivers/net/wireless/iwl-base.c:2279:2:    expected int
> drivers/net/wireless/iwl-base.c:2279:2:    got restricted unsigned short [usertype] flags
> drivers/net/wireless/iwl-4965.c:490:18: warning: restricted degrades to integer
>
>
>
