Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38309 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2HWQTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 12:19:23 -0400
Received: by vbbff1 with SMTP id ff1so978624vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2012 09:19:22 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 09:19:22 -0700
Message-ID: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com> (sfid-20120823_182011_893904_98301877)
Subject: Re: Question about ath9k/mac80211 Driver
From: Patrick Connolly <pjc999@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed,
     Thanks very much for the response.

   Yes I get "Operation not supported":

# iwconfig wlan0 modu 11b
Error for wireless request "Set Modulation" (8B2F) :
    SET failed on device wlan0 ; Operation not supported.

   ...so what does this mean; what are my options here?  In view of
the fact that the capability of changing modes (from 'g' to 'b'
...etc.) is an essential requirement, am I using the wrong driver
...is there a different driver that supports this chip?  Or is it that
there's no driver that supports this chip so that I would have to put
this functionality into ath9k myself if I want it?

   Thanks again for the help.

-Patrick

>
>Hi,
>
>On Thu, Aug 23, 2012 at 2:26 AM, Patrick Connolly <pjc999@gmail.com> wrote:
>> Hello,
>>       I'm new to ath9k and in need of some basic/rudimentary help.
>>       I'm working with an Access Point that uses the ath9k/mac80211
>> driver combination to talk to an Atheros AR9285.  The firmware is
>> OpenWrt.
>>
>>     What is the best command line tool to use to get the driver to
>> switch the chip's mode between 'b', 'g', or 'bg' (mixed) mode?  The
>> OpenWrt Tools we're currently using ("uci" "wifi") are not talking to
>> the driver at all and when we switch settings (between b,g,bg), the
>> beacons go out advertising the same rates regardless of the mode.
>
>i don't think ath9k supports this
>regarding  commands
>
>   iwconfig eth0 modu 11g
>   iwconfig eth0 modu CCK OFDMa
>   iwconfig eth0 modu auto
