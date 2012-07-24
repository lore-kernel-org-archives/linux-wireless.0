Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37915 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2GXPG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 11:06:56 -0400
Received: by gglu4 with SMTP id u4so6748195ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 08:06:56 -0700 (PDT)
Message-ID: <500EBA0C.106@lwfinger.net> (sfid-20120724_170700_797035_BC08E317)
Date: Tue, 24 Jul 2012 10:06:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com>
In-Reply-To: <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2012 08:56 AM, Xavier de Almeida wrote:
> Thanks Larry for your help.
> I tried 3.4.6 and 3.5.0 Quantal kernels but they didn't boot with my i8042 keyboard chip.
>
> So I have installed 3.2.23-030223 and it now starts OK.
>
> FYI here is the new log (I ll have to investigate why the auth between the endpoint and the hotspot doesn't work)
>
> MERCI
> XabiX

Yes, we do make progress. Kernel 3.2.23 has the bug fixes backported from later 
kernels, but there are additional changes that cannot be implemented as they are 
too intrusive. You may still need to incorporate compat-wireless.

Larry



