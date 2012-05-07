Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:62261 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab2EGTym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 15:54:42 -0400
Received: by qabj40 with SMTP id j40so4251201qab.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 12:54:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-j=rzUAZ02w8Zh3D9gX1tkb7LF4MWZbmEZTRBY5fvV4egw@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com>
	<4FA23DA0.3030207@stericsson.com>
	<CABF+-6WjnVxC55iGHwoaL2zJ+_6oLbkVjaqwwLLrQzZxKwwWxw@mail.gmail.com>
	<4FA2BF0A.4040307@stericsson.com>
	<CABF+-6UgQek50abaLnUsBh3LEccG2Pd1vFQDiLyxgcky-JN4Ag@mail.gmail.com>
	<CAFED-jkzELRHGy7pwqDznLqPzhandwZLQEoCEFvw5F6ogMxiYA@mail.gmail.com>
	<CABF+-6WvgwjkrD6WG8GxcXQ+JM7szugFWZbLN6ssJ8589Q7-BA@mail.gmail.com>
	<CABF+-6U8100oTnpaU=anEYtzkktPLvNqp_bm5M+7Yp_Hajv3+w@mail.gmail.com>
	<CAFED-jn+L0oik5aNtz5xukiYn=W7McXp1sB=+SLPHj=Gdk5SBA@mail.gmail.com>
	<CAFED-j=rzUAZ02w8Zh3D9gX1tkb7LF4MWZbmEZTRBY5fvV4egw@mail.gmail.com>
Date: Mon, 7 May 2012 15:54:42 -0400
Message-ID: <CABF+-6UcLN43A2JxD9KeUjG+hL18Uva+AaJEtFZmf_j-uoY1ZQ@mail.gmail.com> (sfid-20120507_215446_151358_44A3CE16)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Please check such patch, some modification added to:
> mac80211: support adding IV-room in the skb for CCMP keys

Thanks for the patch.  Applying it does get rid of the "Slowpath:
tailroom is not big enough" message I was seeing.


Kevin
