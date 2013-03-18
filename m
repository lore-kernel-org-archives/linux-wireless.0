Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:35222 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab3CRVdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 17:33:39 -0400
Received: by mail-da0-f44.google.com with SMTP id z20so1589406dae.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 14:33:39 -0700 (PDT)
Date: Mon, 18 Mar 2013 14:25:44 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, 664767@bugs.debian.org,
	linux-wireless@vger.kernel.org
Subject: Re: Brcmsmac driver woes, possible regression?
Message-ID: <20130318212544.GB5062@elie.Belkin> (sfid-20130318_223348_171348_399945B8)
References: <20130317144603.GA4850@stt008.linux.site>
 <1363532310.3937.266.camel@deadeye.wl.decadent.org.uk>
 <20130317152428.GA4940@stt008.linux.site>
 <20130317175658.GA8181@elie.Belkin>
 <20130317182725.GA5811@stt008.linux.site>
 <20130317183344.GA8786@elie.Belkin>
 <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com>
 <20130318083752.GA6570@elie.Belkin>
 <51476D25.6030609@broadcom.com>
 <20130318211428.GA9136@stt008.linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130318211428.GA9136@stt008.linux.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camaleón wrote:
> El 2013-03-18 a las 20:38 +0100, Arend van Spriel escribió:

>> Sorry to hear. Reading back the bug report I noticed you are having a  
>> bcm4313 and we recently had a regression on it. Could you provide  
>> debugfs information from <debugfs_mount>/brcmsmac/bcma0:0/hardware
>
> I see. My "/sys/kernel/debug/*" directory is empty

mount -t debugfs debugfs /sys/kernel/debug
