Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.legal.de ([46.38.240.131]:37074 "EHLO mail.legal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab2K1SDb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 13:03:31 -0500
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Fwd: Re: iwlwifi hibernate / suspend issue
From: Jens Kapitza <j.kapitza@schwarze-allianz.de>
Date: Wed, 28 Nov 2012 19:04:11 +0100
To: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Message-ID: <45226907-f8cf-4076-b458-122325a38eb7@email.android.com> (sfid-20121128_190334_573617_4BCFAC5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

forgot to cc the mailing list


-------- Original-Nachricht --------
Von: Jens Kapitza <j.kapitza@schwarze-allianz.de>
Gesendet: Wed Nov 28 18:58:34 MEZ 2012
An: Johannes Berg <johannes@sipsolutions.net>
Betreff: Re: iwlwifi hibernate / suspend issue





Johannes Berg <johannes@sipsolutions.net> schrieb:

>On Wed, 2012-11-28 at 16:21 +0100, Jens Kapitza wrote:
>> > just enter "dmesg" and pastebin the result somewhere
>
>> this line seems to be wrong
>> 
>>   [ 4650.687346] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable
>radio.
>
>Well, it's not necessarily wrong, it indicates that the device read
>that
>the rfkill line was pulled low ("rf should be off").
ok but why not up again at resume
>
>You said reloading the module fixes this, which is interesting since

no  i have to restart the computer 

>the
>device should be sending interrupts whenever the state changes, so even
>if it was reading the wrong state at resume time (as it does now) it
>should catch up later...
>

is there a chance to reset the interrupt or the state on resume
>johannes
jens

-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
