Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f200.google.com ([209.85.222.200]:56287 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0CRBx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 21:53:27 -0400
Received: by pzk38 with SMTP id 38so1374429pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 18:53:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e891003171550i27531f3bl4e4692494ec36b8@mail.gmail.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
	<43e72e891003171532x5e9893dfmfc1fb469a638d76e@mail.gmail.com>
	<43e72e891003171550i27531f3bl4e4692494ec36b8@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 17 Mar 2010 18:53:06 -0700
Message-ID: <43e72e891003171853v7458802bgafcf060d75e240a7@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] ath9k_hw: ar93xx initial abstraction work
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 3:50 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Mar 17, 2010 at 3:32 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Wed, Mar 17, 2010 at 3:27 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> Here's what I have so far, this is rebased on top of Senthil's patches
>>> for ath9k_htc posted today. Just tested it on my AR9280, it doesn't
>>> break anything.
>>
>> BTW the new ath9k_htc series + this series can be downloaded in one file from:
>>
>> http://bombadil.infradead.org/~mcgrof/tmp/all-ar93xx-03-17-v3.patch
>
> bleh, I did not use -M here... let me resend with that for the renames.

On second thought John -- please hold off on merging these new ar93xx
abstraction patches, we are trying to mathematically prove if ar9002
register definitions are the same as the ar9003 ones and if so well
this is all pointless :D

  Luis
