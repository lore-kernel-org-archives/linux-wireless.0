Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:54944 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYA2Cqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 21:46:47 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1887616rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2008 18:46:41 -0800 (PST)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: it's problem : ath5k - 3com 3CRDAG675B
Date: Tue, 29 Jan 2008 11:46:37 +0900
Message-ID: <001501c86221$2c98bfb0$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080129_024650_097572_CCE384CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello~ everyone~ I'm new here. nice to meet you. :-)

I bought some of NICs supporting 802.11a (3com : 3CRDAG675B PCI adapter=
) to
test 802.11a ad-hoc. It uses ath5k driver.
recently, to test about 802.11a ad-hoc I compiled combat-wireless-2.6
driver and did 'make load'.
Ath5k Driver is loaded successfully. But, when I made a wireless
configuration (iwconfig essid ath5k mode ad-hoc channel 44), after that=
 it
takes long time for making a connection between two NICs.
So, I tried to switch to 802.11b or 802.11g. But also long time.

and after connecting between two NICs, I tested ping-request. In MS win=
dows
command line, ping-request is time out so often and in linux, it's not =
time
out but rtt is very slow and irregular.

if somebody know why, please help me~~

thanks.


p.s of course, kernel version is higher than 2.6.22.

--
--
Have a Wonderful Day~~!!
=B1=E8=BF=B5=C8=AF (James-Youngwhan Kim)
yhkim@corebell.co.kr
cs010101@gmail.com
+82-42-863-0340
+82-10-6753-0987
HTVC 3106 KAIST, 373-1 Guseong-dong, Yuseong-gu, Daejon,  Republic of K=
orea
305-701



-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
