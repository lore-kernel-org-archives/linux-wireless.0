Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:64869 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbZJ3UDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 16:03:35 -0400
Received: by iwn10 with SMTP id 10so2389988iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 13:03:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1094614475.20091030230028@mail.ru>
References: <1094614475.20091030230028@mail.ru>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 30 Oct 2009 13:03:20 -0700
Message-ID: <43e72e890910301303r67fea6b1m3e04b267aceec66b@mail.gmail.com>
Subject: Re: ieee80211_tx_status: headroom too small
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2009 at 1:00 PM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
> Hello people,
>
> I'm using compat-wireless-2009-09-14 with 2.6.25.20 and I have
> recently noticed lots of these in syslog:
>
> ieee80211_tx_status: headroom too small
> ieee80211_tx_status: headroom too small
> ieee80211_tx_status: headroom too small
>
> The wireless (access point) works fine, though maybe not very
> fast. However, this warning somehow bothers me. Is it important?
> Does it mean something critical? Maybe I should just comment
> it out in the code? I don't like syslog being filled up this
> way...

You're lucky it even worked on 2.6.25.

  Luis
