Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54480 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1HJO5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 10:57:31 -0400
Received: by gwaa12 with SMTP id a12so707344gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 07:57:30 -0700 (PDT)
Message-ID: <4E429C57.1040101@lwfinger.net> (sfid-20110810_165734_392543_434A4F62)
Date: Wed, 10 Aug 2011 09:57:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: kc@cobradevil.org
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu sometimes it can authenticate to ap
References: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org> <34676454425401d650be733a43191a53@cobradevil.org> <532595cb4d5ef910de54a4736ba76185@cobradevil.org> <4E41624E.3010904@lwfinger.net> <d3faeaf2e881a324b0ad3102c10e6131@cobradevil.org>
In-Reply-To: <d3faeaf2e881a324b0ad3102c10e6131@cobradevil.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2011 08:32 AM, kc@cobradevil.org wrote:
> Hello Larry,
>
> did you receive my last email with the log files?
> i'm not sure if that the right information so if you need more the please let me
> know.

Yes, I got them.

So far, the only conclusion from them is that you should install the CRDA 
package. That is not the cause of your problem, but it needs to be done.

I can duplicate the problem here and find that it occurs between 3.0 and 
3.1-rc1. I first tried to bisect testing only drivers/net/wireless/rtlwifi, 
net/mac80211 and net/wireless directories. That led to an impossible "bad" 
commit, thus I'm having to bisect the whole tree.

I'll let you know what I find.

Larry
