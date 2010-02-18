Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61105 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab0BRT5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 14:57:37 -0500
Received: by ewy19 with SMTP id 19so7245292ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Feb 2010 11:57:36 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH v3] mac80211: deprecate RX status noise
References: <1266437114.23447.0.camel@jlt3.sipsolutions.net>
	<1266447118.12365.21.camel@mj>
	<1266494831.6261.1.camel@jlt3.sipsolutions.net>
	<201002181541.45835.holgerschurig@gmail.com>
	<1266504527.6261.2.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 18 Feb 2010 21:57:31 +0200
In-Reply-To: <1266504527.6261.2.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Thu\, 18 Feb 2010 15\:48\:47 +0100")
Message-ID: <878waqgvv8.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> I'm not saying that I understand this completely, but for me it 
>> would make sense to disable iwlwifi's broken noise reporting 
>> only. No reason to disable it for everyone if some of them are 
>> broken.
>
> Well it's kinda bound to be broken elsewhere too because we don't even
> know how various devices gather the values. With iwlwifi at least we
> know how it gets the value.

Also wl1251 is more or less broken related to noise reporting. I even
tried to find information how to use it properly but didn't get
anything.

-- 
Kalle Valo
