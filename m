Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61545 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaDINZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:25:11 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so2482385wgh.35
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:25:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397049772.4418.71.camel@dubbel>
References: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	<1397049062-24177-1-git-send-email-michal.kazior@tieto.com>
	<1397049062-24177-2-git-send-email-michal.kazior@tieto.com>
	<1397049772.4418.71.camel@dubbel>
Date: Wed, 9 Apr 2014 15:25:09 +0200
Message-ID: <CA+BoTQmOGvjzcH5RDW=7MFqtw3xvX3aEpKmHQeGWc8bghEg9GQ@mail.gmail.com> (sfid-20140409_152528_502348_C84EFA47)
Subject: Re: [PATCH v4 1/4] mac80211: fix CSA tx queue locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 April 2014 15:22, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-04-09 at 15:10 +0200, Michal Kazior wrote:
>> v4:
>>  * improve commit message (locked vs stopped) [Luca]
>
> Maybe the subject should be changed too? But I think either Johannes or
> I (whoever apply the series) can easily fix it up while applying...

/me grabs my head

Please do. Thanks!


Michał
