Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:47628 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaBSSvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 13:51:35 -0500
Received: by mail-lb0-f177.google.com with SMTP id 10so590618lbg.36
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 10:51:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 19 Feb 2014 10:51:14 -0800
Message-ID: <CAB=NE6XQs17pWVWchN8FJrv9HZwzkOF94iCPY=nx1BsJ5_bLcg@mail.gmail.com> (sfid-20140219_195139_406878_96002AE6)
Subject: Re: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth calculation
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 30, 2014 at 12:52 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
>
> We don't need any changes in CRDA or internal regulatory.

What happens if an old kernel gets a new wireless-regdb with AUTO on
all of its 5 GHz regdomain for the country it using ? I see no mention
of this anywhere in the documentation and at least from the code
review I just did it seemed like we'd use 0. I hope I'm wrong as
otherwise that'd introduce a severe regression when this is introduced
to wireless-regdb.

  Luis
