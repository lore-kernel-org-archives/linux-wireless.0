Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36482 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbcEaMbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 08:31:02 -0400
Received: by mail-wm0-f53.google.com with SMTP id n129so129140182wmn.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2016 05:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zir6ctpc.fsf@toke.dk>
References: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	<1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
	<87zir6ctpc.fsf@toke.dk>
Date: Tue, 31 May 2016 14:31:00 +0200
Message-ID: <CA+BoTQkUt1rxLwX4oBYi4QhLMe+2nGJuE+pG3nguTDJdJsZ8vg@mail.gmail.com> (sfid-20160531_143107_385706_E98AE680)
Subject: Re: [Make-wifi-fast] [PATCHv5 0/5] mac80211: implement fq_codel
From: Michal Kazior <michal.kazior@tieto.com>
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 May 2016 at 14:12, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This patchset disables qdiscs for drivers
>> using software queuing and performs fq_codel-like
>> dequeuing on txqs.
>
> Hi Michal
>
> Is this version in a git repo somewhere I can pull from? :)

Just pushed, enjoy!

  https://github.com/kazikcz/linux/tree/fqmac-v5


Michał
