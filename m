Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63035 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKW4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 18:56:12 -0400
Received: by mail-pb0-f45.google.com with SMTP id ro8so4265701pbb.18
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 15:56:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513E5E7D.2050705@gmail.com>
References: <513E5E7D.2050705@gmail.com>
Date: Mon, 11 Mar 2013 15:56:11 -0700
Message-ID: <CAJ-Vmokdusg+fEX9Ac100abzEdOLRy+F4CDOVcbv-VhOtVbF3Q@mail.gmail.com> (sfid-20130311_235616_109633_B67AD879)
Subject: Re: [PATCH] ath9k: Allow over-riding reg-domain.
From: Adrian Chadd <adrian@freebsd.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: greearb@candelatech.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh I hate you. ;-)

Besides, that will not work on AR9300 NICs with only OTP.



Adrian


On 11 March 2013 15:45, Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:
> Ben Greear wrote:
>
>> Otherwise, can't get the Sparklan AR9380 NICs to be
>> 5Ghz APs, since they are in world-roaming domain by
>> default.  Add this to /etc/modprobe.d/ath9k.conf:
>
> You can use atheros branch [0] of iwleeprom [1] to
> manipulate the EEPROM.
>
> And you should read: http://wireless.kernel.org/en/users/Drivers/ath#Regulatory
>
>
> [0] svn co http://iwleeprom.googlecode.com/svn/
> [1] http://code.google.com/p/iwleeprom/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
