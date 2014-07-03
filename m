Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58806 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaGCG0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 02:26:42 -0400
Received: by mail-la0-f46.google.com with SMTP id el20so7722598lab.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2014 23:26:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WN=6cu1rfHjLV32bvwAY6tnW9wrpVx5WHfdu0SJMvC0A@mail.gmail.com>
References: <1404302531-18132-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6WN=6cu1rfHjLV32bvwAY6tnW9wrpVx5WHfdu0SJMvC0A@mail.gmail.com>
Date: Thu, 3 Jul 2014 08:26:40 +0200
Message-ID: <CALhHN=pfaLS_Axuky82QkUy1yaJw7qd+_Sss5h3nti9Li2g1Fw@mail.gmail.com> (sfid-20140703_082647_182723_9FE7D373)
Subject: Re: [PATCH] crda: db2rd, parse/print CAC time
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 July 2014 00:06, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Wed, Jul 2, 2014 at 5:02 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> db2rd, parse and print DFS CAC time
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
>
> This doesn't print the DFS CAC if its a in a line like this:
>
> (5250 - 5330 @ 0), (20), (60000), DFS, AUTO-BW
>
will check this, BTW BW=0 is not allowed I think.

BR
Janusz
