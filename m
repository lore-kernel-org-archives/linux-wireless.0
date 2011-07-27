Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57120 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab1G0VAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 17:00:30 -0400
Received: by qyk9 with SMTP id 9so1184821qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2011 14:00:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20110727T224259-350@post.gmane.org>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W76260EA23039CA8000DB88A320@phx.gbl>
 <CAB=NE6Wcn3-GwqPJQDXOT0JCNnZgCs1E7HecWrXpc8LS+XRyDA@mail.gmail.com>
 <201107262031.11394.chunkeey@googlemail.com> <CAB=NE6WoGZfpGnNkdaLdtN+nC+aM1mxV4rkUCMarnuDonQeJeg@mail.gmail.com>
 <COL114-W2204F3FA55EF4C0D20D0C58A350@phx.gbl> <CAB=NE6WCagRUrMynd2CoAAN_LtoVkaoCYxOLE1COKx9zXgCBuQ@mail.gmail.com>
 <loom.20110727T224259-350@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 27 Jul 2011 14:00:09 -0700
Message-ID: <CAB=NE6UKkLTwkUR_r=WdUAwPRq=vTWGb4Y3FqN73RBU3_3a0Qg@mail.gmail.com> (sfid-20110727_230034_409725_E3C3F389)
Subject: Re: problem on ACS
To: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 27, 2011 at 1:55 PM, Swaminathan Vasanth
<swaminathanvasanth.r@gmail.com> wrote:
>
> Hi all,
>  @ MingAnn Ng > If you increase the value for acs_num_req_surveys and
> acs_roc_duration_ms, you will not get -inf as the interference value. I faced
> this problem initially, but with more number of surveys ACS actually picks the
> best channel.
>  @ Luis > I got convincing results on Channel selection. I also cross verified
> the selected channel and the channels used by the nearby AP's through Kismet.
> With 9 AP's using different channel, ACS selected the channel which was least
> used. Great Work Luis !

Wow, awesome, thanks for the verification of the work :) truly the
implementation was just a rush job for an "intermediary" solution for
people who want ACS until we get Spectral Scan ACS support upstream.
Glad its working out as such.

  Luis
