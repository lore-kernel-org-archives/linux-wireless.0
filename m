Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:3656 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYJHMk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 08:40:26 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2694599fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2008 05:40:24 -0700 (PDT)
Message-ID: <1ba2fa240810080540m32134461t26096022d11c6dfa@mail.gmail.com> (sfid-20081008_144030_146591_7C83918E)
Date: Wed, 8 Oct 2008 14:40:24 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT capabilities IE
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223460098.3618.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223460098.3618.53.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 8, 2008 at 12:01 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
> quick question, I can't seem to read that from the draft, is the HT
> capabilities IE supposed to be constant when, say, sent from an AP in
> every beacon? Most fields look very constant, but e.g. the SM power save
> mode might not be?

SM has to be changed using action frame by the spec IIRC

Tomas
