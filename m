Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57704 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2FSNaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 09:30:16 -0400
Received: by lbbgm6 with SMTP id gm6so5761895lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 06:30:14 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 21:30:14 +0800
Message-ID: <CAL74qpEwZZF2LrfH1xxYNOxCGPBtT=6UKD99w4hsFr5Hzf8h+Q@mail.gmail.com> (sfid-20120619_153020_137104_345BC7D3)
Subject: turn off scanning
From: =?GB2312?B?1bLUtA==?= <zhanyuan.roger@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all!

I want to modify the 802.11 stack code to turn off sw_scanning in STA.
It's just a personal purpose because my STA has no need to connect to
a AP. STA just stays on the operation channel.

So I want to know which part in mac80211 folder(or other places)
should I modify? I am a new kernel developer, and it's my pleasure to
get any help!

Roger
