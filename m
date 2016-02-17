Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33439 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbcBQHF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 02:05:29 -0500
MIME-Version: 1.0
In-Reply-To: <CABPxzYJ6zt32b-U0KPuJRSo144Z=pBngieMv8sBaAHBJSnAKVA@mail.gmail.com>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
 <1455658091-28262-1-git-send-email-apenwarr@gmail.com> <1455660329.2723.16.camel@sipsolutions.net>
 <CAHqTa-1kBz3WouxUyNBMemY-Gp0y5v8CR6G_6K2hf8nRB9r7Fg@mail.gmail.com> <CABPxzYJ6zt32b-U0KPuJRSo144Z=pBngieMv8sBaAHBJSnAKVA@mail.gmail.com>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Wed, 17 Feb 2016 02:05:09 -0500
Message-ID: <CAHqTa-06c-agN5x8+otXGA8oyLmFf3A4pz8_qgo7bw4ScobYjQ@mail.gmail.com> (sfid-20160217_080533_888361_52FE61B3)
Subject: Re: ath9k(?): AP stops sending traffic to iPhone 4S until another
 802.11n-capable STA joins
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2016 at 1:23 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> From a quick glance of symptoms, i think the below patch is worth a
> try, even though
> i don't see you are doing any background scans for which this applies.
>
> https://patchwork.kernel.org/patch/8015321/

Thanks, Krishna.  We are in fact doing background scans occasionally,
however, none was in progress around the time of the glitch, and the
problem was still reproducible with background scans disabled.  We
also aren't combining AP and STA on the same radio (in this particular
use case).
