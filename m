Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40474 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2GXRvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 13:51:07 -0400
Received: by yenl2 with SMTP id l2so6947510yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 10:51:06 -0700 (PDT)
Message-ID: <500EE086.6000304@lwfinger.net> (sfid-20120724_195111_569751_40197432)
Date: Tue, 24 Jul 2012 12:51:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com>
In-Reply-To: <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2012 12:06 PM, Xavier de Almeida wrote:
> Hi Larry and the team,
>
> couldn't install my compiled (make + checkinstall) package.
>
> sudo dpkg -i compat-wireless-2012-07_03-1_i386.deb
> (Reading database ... 214923 files and directories currently installed.)
> Unpacking compat-wireless-2012-07 (from compat-wireless-2012-07_03-1_i386.deb) ...
> dpkg: error processing compat-wireless-2012-07_03-1_i386.deb (--install):
>   trying to overwrite '/bin/ntfs-3g', which is also in package ntfs-3g 1:2012.1.15AR.1-1ubuntu1
> dpkg-deb: error: subprocess paste was killed by signal (Broken pipe)
> Errors were encountered while processing:
>   compat-wireless-2012-07_03-1_i386.deb
>
> Should I just to a make install instead?

Yes. Using "make" and "sudo make install" is the correct way. Building a .deb. 
may be necessary to install a whole kernel (it is not on my distro), but not for 
compat-wireless.

Larry



