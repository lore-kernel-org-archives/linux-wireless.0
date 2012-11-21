Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53992 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KULLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 06:11:55 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so6897928obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2012 03:11:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353494712.10444.20.camel@jlt4.sipsolutions.net>
References: <1353381362-437-1-git-send-email-sujith@msujith.org>
	<1353494712.10444.20.camel@jlt4.sipsolutions.net>
Date: Wed, 21 Nov 2012 13:11:54 +0200
Message-ID: <CANUX_P3e4ut9Jh25wXP7dOcvQh_YhuZ_LCkQV4QHpaNGrzbYuQ@mail.gmail.com> (sfid-20121121_121158_626127_C4483E06)
Subject: Re: [PATCH] mac80211: Add debugfs callbacks for station addition/removal
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> Provide drivers with hooks to create debugfs files when
>> a new station is added. This would help drivers to take
>> advantage of mac80211's station list infrastructure and not maintain
>> tedious station management code internally.
>
> Applied.
>

Do you see value to add this for vif too?
