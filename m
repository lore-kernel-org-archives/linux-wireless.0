Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34559 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbcHPSO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 14:14:58 -0400
Received: by mail-wm0-f66.google.com with SMTP id q128so17765397wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 11:14:39 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sambhu R <rsambhu@am.amrita.edu>
Cc: linux-wireless@vger.kernel.org
Subject: Re: regarding RTL8188SU
Date: Tue, 16 Aug 2016 20:14:36 +0200
Message-ID: <3253531.4E4A9cUeqj@debian64> (sfid-20160816_201543_419437_E54EDB4C)
In-Reply-To: <1902731527.3857839.1471349378230.JavaMail.zimbra@am.amrita.edu>
References: <1902731527.3857839.1471349378230.JavaMail.zimbra@am.amrita.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Tuesday, August 16, 2016 5:39:38 PM CEST Sambhu R wrote:
> I was following your--> https://github.com/chunkeey/rtl8192su but i couldn't
> install. When i execute ./install.sh i'm getting the following error.

There's no install.sh file in this repository?! 

> 
> make[1]: Entering directory '/usr/src/linux-headers-3.4.112-sun8i'
> Makefile:568: /usr/src/linux-headers-3.4.112-sun8i/arch/armv7l/Makefile: No such file or directory
> make[1]: *** No rule to make target '/usr/src/linux-headers-3.4.112-sun8i/arch/armv7l/Makefile'.  Stop.
> make[1]: Leaving directory '/usr/src/linux-headers-3.4.112-sun8i'
> Makefile:220: recipe for target 'modules' failed
> make: *** [modules] Error 2
> ##################################################
> Compile make driver error: 2
> Please check error Mesg
> ##################################################
> 
> please help..
Please look at the project's README.md [0].

"This is "a" driver repository for the WIP rtl8192su for any
interested developer.

To build the driver you will need to have a recent and compatible kernel
source. Currently, only kernels built from the latest wireless-testing.git
are supported. If you want to know more about wireless-testing.git then
visit Linux wireless wiki's Git-Guide [1]."

[0] <https://github.com/chunkeey/rtl8192su#readme>
[1] <https://wireless.wiki.kernel.org/en/developers/Documentation/git-guide>
