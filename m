Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:46774 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaFLFBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 01:01:12 -0400
Received: by mail-qa0-f44.google.com with SMTP id j7so1002513qaq.31
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 22:01:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140611204207.GD6042@wotan.suse.de>
References: <20140519185046.GH7650@tuxdriver.com>
	<CALhHN=pEo5H4AnWpOAhPs8LyK35wyhGJyvHTrh12nauQ-tOpDg@mail.gmail.com>
	<20140611204207.GD6042@wotan.suse.de>
Date: Thu, 12 Jun 2014 07:01:10 +0200
Message-ID: <CALhHN=pTG-06H80bs11NT82wc009xgZ-aghpn_BBryxj9mvXng@mail.gmail.com> (sfid-20140612_070116_953642_0E2DF1A5)
Subject: Re: [wireless-regdb] [ANN] wireless-regdb: master-2014-05-19
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 June 2014 22:42, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Wed, Jun 11, 2014 at 09:15:19PM +0200, Janusz Dziedzic wrote:
>> On 19 May 2014 20:50, John W. Linville <linville@tuxdriver.com> wrote:
>> > A new release of wireless-regdb (master-2014-05-19) is available at:
>> >
>> > http://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2014.05.19.tar.gz
>> >
>> > Here is the short log of the changes included since the 2013-11-27
>> > release:
>> >
>> > Bjørn Mork (1):
>> >       wireless-regdb: update NO's regulatory rules
>> >
>> > Janusz Dziedzic (3):
>> >       wireless-regdb: allow max bandwidth to be AUTO calculated
>> >       wireless-regdb: set AUTO bandwidth for world regulatory
>> This two above should not be merged. That was first version of auto
>> bandwidth calculation, we skip :)
>
> How about on CRDA? Can you check if I merged the wrong stuff as I already
> pushed as well? This also currently breaks the parses are there is no
> support for the auto stuff yet.
>
crda: add AUTO-BW rule flag support - this is correct one.

BR
Janusz
