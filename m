Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51355 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab1JEWbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 18:31:39 -0400
Received: by qadb15 with SMTP id b15so1629494qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 15:31:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=TACq_d7JU0stibcqnvWgzUO7Ozue=4VayeHNcgXTejw@mail.gmail.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <201110032124.53937.chunkeey@googlemail.com> <CAB=NE6XBkisvFmj6F7wS6i8XV7WEsM6bQ5zsXFWXm9XM8z0pwA@mail.gmail.com>
 <201110041538.12885.chunkeey@googlemail.com> <4E8B157F.2080203@neratec.com> <CAJ-Vmo=TACq_d7JU0stibcqnvWgzUO7Ozue=4VayeHNcgXTejw@mail.gmail.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 5 Oct 2011 15:31:19 -0700
Message-ID: <CAB=NE6VvLP6qqNENoUhu9N4wpKS0WGbCj1hTV-aWzPytjLVg4w@mail.gmail.com> (sfid-20111006_003143_107901_92D1332F)
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
To: Adrian Chadd <adrian@freebsd.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 4, 2011 at 7:34 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> .. erm, how complicated is the pattern matching code when it's compiled?
>
> The port of the fusion radar detection module didn't end up being all that big.

Adrian, please keep terms like "fusion codebase" out of public lists.

  Luis
