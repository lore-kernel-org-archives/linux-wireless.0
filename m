Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49845 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0AZIlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 03:41:21 -0500
Received: by ewy19 with SMTP id 19so699517ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 00:41:20 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j\@w1.fi" <j@w1.fi>, Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	<43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	<1264189560.2593.14.camel@johannes.local>
	<43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
	<1264205494.7208.7.camel@wwguy-ubuntu>
	<43e72e891001221623v477b9fady32237c1a3aededda@mail.gmail.com>
	<1264206170.7208.8.camel@wwguy-ubuntu>
	<1264250814.2593.25.camel@johannes.local>
	<43e72e891001251018h1a62e1ccn4a7d1411fa2c0615@mail.gmail.com>
	<1264444418.23766.53.camel@johannes.local>
	<43e72e891001251155l504a74fcpf20942682ca340c1@mail.gmail.com>
	<1264449969.23766.59.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 26 Jan 2010 10:41:15 +0200
In-Reply-To: <1264449969.23766.59.camel@johannes.local> (Johannes Berg's message of "Mon\, 25 Jan 2010 21\:06\:09 +0100")
Message-ID: <87fx5tntqs.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> I'll need to analyse this in more detail, and also what drivers do.
>
> Kalle, could wl12x1 deal with getting the DTIM only when enabling PS?

Yes, wl1251 sets dtim with wl1251_acx_wr_tbtt_and_dtim() and it should
be enough to set it before enabling PS.

-- 
Kalle Valo
