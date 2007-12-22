Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:12702 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbXLVUzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 15:55:50 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1437075wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2007 12:55:49 -0800 (PST)
Message-ID: <1ba2fa240712221255q2daee8eehf84e1a5829ad2ac0@mail.gmail.com> (sfid-20071222_205614_275876_07828EB4)
Date: Sat, 22 Dec 2007 22:55:49 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add unified BSS configuration
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1198109817.16241.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1198109817.16241.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Tomas, I'm a bit confused that iwl3945 doesn't use the erp_ie_changed
> callback but iwl4965 does.
This is because some smart guy was eager to split the driver before we
had a chance to fix it proper way

 This seems like something that should be
> addressed. I hope with this patch you can get rid of the frame sniffing
> code.
This is on my first priority after pushing HT patches.
Except assoc id we need also TSF from the beacon before we can drop
the sniffing code.
Thanks
Tomas
