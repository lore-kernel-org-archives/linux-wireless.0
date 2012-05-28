Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59292 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2E1J0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 05:26:13 -0400
Received: by bkcji2 with SMTP id ji2so2032405bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2012 02:26:11 -0700 (PDT)
Message-ID: <4FC344B1.2080700@googlemail.com> (sfid-20120528_112634_678760_F9932DF0)
Date: Mon, 28 May 2012 11:26:09 +0200
From: Torsten Zimmermann <flottetotte@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: injected packet channel switch
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

i already posted this on the ath9k list, but maybe this fits more on 
this list here.
i'm fairly new to this topic and try to figure out how to switch the
channel for injected packets based on the information set in the radiotap
header. this is just for an experiment we are running at our university.

the goal is to parse the information provided by radiotap header
in a modified mac80211/tx, set the channel and switch back to the previous
channel setting after the packet has been transmitted.

moreover, the packet should - if transmission failed - not be queued. but
the more important thing right now is the "injected packet channel 
switch and back after transmission".

has someone else already tried such a modification or has some good hints
were to start ? (i know about the parsing of the header but i am not 
sure how to solve the channel switching
for one packet in an elegant way)

thanks,
torsten
