Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35397 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbbFBAQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 20:16:39 -0400
Received: by igbyr2 with SMTP id yr2so75103340igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 17:16:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433185600.4861.42.camel@perches.com>
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
 <1433181735-15712-2-git-send-email-patila@marvell.com> <1433185600.4861.42.camel@perches.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 2 Jun 2015 10:16:18 +1000
Message-ID: <CAGRGNgXX+3u1vtCAbXJ9epnM2=Hjnd6eJbJj1nG=SaNLw7Uobg@mail.gmail.com> (sfid-20150602_021642_861691_BC35535F)
Subject: Re: [PATCHv4 01/17] mwifiex: verbose logging for association failure messages
To: Avinash Patil <patila@marvell.com>
Cc: Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>, cluo@marvell.com,
	huxm@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Avinash,

On Tue, Jun 2, 2015 at 5:06 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2015-06-01 at 23:31 +0530, Avinash Patil wrote:
>> This patch adds more detailed information about association failures
>> - reason and states.
>>
>> Signed-off-by: Avinash Patil <patila@marvell.com>
>> Signed-off-by: Cathy Luo <cluo@marvell.com>
>> Reviewed-by: Joe Perches <joe@perches.com>
>
> Hello Avinash.
>
> I didn't sign this.
>
> In the future, please do not add sign-off type signatures
> for others that do not actually give you some signature.

If this was inspired by some comment Joe made, there's "Reported-by"
and "Suggested-by" for crediting him with the idea, that said, it's
still a little rude to add them without permission.

See section 13 of https://www.kernel.org/doc/Documentation/SubmittingPatches

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
